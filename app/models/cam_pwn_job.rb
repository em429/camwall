class CamPwnJob < ApplicationRecord
  QUERIES = {
    android_webcam_server: %(title:"Android Webcam Server"),
    has_screenshot_port_554: %(has_screenshot:true port:554),
    webcam_has_screenshot: %(webcam has_screenshot:true),
    device_webcam: %(device:webcam),
    title_camera: %(title:camera)
  }.freeze

  def fetch_new_cams(shodan_api_key, query)
    client = Shodanz.client.new(key: shodan_api_key)

    Rails.logger.debug "Fetching new cams using:  #{query} and #{shodan_api_key}"
    Rails.logger.debug "Fetching new cams using:  #{query} and #{shodan_api_key}"
    Rails.logger.debug "Fetching new cams using:  #{query} and #{shodan_api_key}"

    client.host_search(query, page: rand(1..30))['matches']
    ## [[]]
  end

  def confirm_cam(cam)
    # TODO: temporary 'brake' for develepoment! remove it later L=
    # return []
    cmd = "ffprobe -v quiet -print_format json -show_streams rtsp://#{cam['ip_str']}/live/ch00_0"
    Rails.logger.debug cmd
    Rails.logger.debug "Checking #{cam['ip_str']} - #{cam['country_code']}"

    begin
       status = Timeout.timeout(15) do
         raw_r = `#{cmd}`
         sleep(0.5)
         JSON.parse raw_r
       end
    rescue StandardError => e
      Rails.logger.debug 'Exception!'
      Rails.logger.debug e
      JSON.parse '{}'
     end
  end

  def upsert_cam(cam)
    Cam.upsert({
                 ip: cam['ip_str'].to_s,
                 port: cam['port'],
                 isp: cam['isp'].to_s,
                 asn: cam['asn'].to_s,
                 org: cam['org'].to_s,
                 city: cam['location']['city'].to_s,
                 country_name: cam['location']['country_name'].to_s,
                 country_code: cam['location']['country_code'].to_s,
                 screenshot: cam['screenshot']['data'].to_s,
                 os: cam['os'].to_s,
                 shodan_timestamp: cam['timestamp'],
                 longitude: cam['location']['longitude'],
                 latitude: cam['location']['latitude'],
                 shodan_response: cam['data']
               },
               unique_by: :ip)
  end

  def gather_cams(shodan_api_key, query)
    cams = fetch_new_cams(shodan_api_key, query)

    cams.each do |cam|
      # Confirm the cam works
      # Check if there is anything inside the returned object
      r = confirm_cam(cam)

      # Skip to next cam if response is empty
      next unless r.any?

      Rails.logger.debug "Upserting camera: #{cam['ip_str']}"
      upsert_cam(cam)
    end
  end
  handle_asynchronously :gather_cams # always run as a delayed job
end
