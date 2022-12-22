class CamPwnJob < ApplicationRecord
  # SHODAN_API_KEY = ENV['SHODAN_API_KEY'] || 'RwhzAhS33ZTwpx8Q9hxAP5ZWxQdsBf1q'
  SHODAN_API_KEY = ENV['SHODAN_API_KEY'] || 'ULAqZuKzub6waFpbmlpvrLdek5QDsXYB'

  QUERIES = {
    android_webcam_server: %(title:"Android Webcam Server"),
    has_screenshot_port_554: %(has_screenshot:true port:554),
    webcam_has_screenshot: %(webcam has_screenshot:true),
    device_webcam: %(device:webcam),
    title_camera: %(title:camera)
  }.freeze

  def fetch_new_cams
    client = Shodanz.client.new(key: SHODAN_API_KEY)

    Rails.logger.debug 'Fetching new Cams..'

    client.host_search('has_screenshot:true port:554', page: rand(1..30))['matches']
  end

  def confirm_cam(cam)
    cmd = "ffprobe -v quiet -print_format json -show_streams rtsp://#{cam['ip_str']}/live/ch00_0"
    Rails.logger.debug cmd
    # Rails.logger.debug "Checking #{cam['ip_str']} - #{cam['country_code']}"

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
                 isp: cam['isp'].to_s,
                 city: cam['location']['city'].to_s,
                 country_name: cam['location']['country_name'].to_s,
                 country_code: cam['location']['country_code'].to_s,
                 screenshot: cam['screenshot']['data'].to_s,
                 shodan_timestamp: cam['timestamp'],
                 longitude: cam['location']['longitude'],
                 latitude: cam['location']['latitude'],
                 shodan_response: cam['data'],
                 port: cam['port']
               },
               unique_by: :ip)
  end

  def gather_cams
    cams = fetch_new_cams

    cams.each do |cam|
      # Confirm the cam works
      # Check if there is anything inside the returned object
      r = confirm_cam(cam)

      # Skip to next cam if response is empty
      next unless r.any?

      Rails.logger.debug "Inserting camera: #{cam['ip_str']}"
      upsert_cam(cam)
    end
  end
  handle_asynchronously :gather_cams # always run as a delayed job
end
