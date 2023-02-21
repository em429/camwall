class SearchNProbeJob < ApplicationJob
  queue_as :default
  
  QUERIES = {
    android_webcam_server: %(title:"Android Webcam Server"),
    has_screenshot_port_554: %(has_screenshot:true port:554),
    webcam_has_screenshot: %(webcam has_screenshot:true),
    device_webcam: %(device:webcam),
    title_camera: %(title:camera)
  }.freeze

  # TODO implement properly
  PAGES = {
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    random: "random"
  }.freeze

  def search_shodan(shodan_api_key, query, page="1")
    client = Shodanz.client.new(key: shodan_api_key)

    Rails.logger.debug "Fetching new cams using:  #{query} and #{shodan_api_key}"

    if page == "random"
      selected_page = rand(1..30)
    else
      selected_page = page
    end
   
    begin
      cams = client.host_search(query, page: selected_page)['matches']
    rescue RuntimeError => e
      Rails.logger.debug "Error while accessing Shodan API. Please try again later. Message: #{e.message}"
    rescue Exception => e
      Rails.logger.debug "Exception! ==> #{e.class} ==> Message: #{e.message}"
    else
      Rails.logger.debug "Cams successfully retrieved from Shodan page #{selected_page}"
    end
    
    cams
  end

  def confirm_cam(cam)
    cmd = "ffprobe -v quiet -print_format json -show_streams rtsp://#{cam['ip_str']}/live/ch00_0"
    Rails.logger.debug "Checking #{cam['ip_str']} - #{cam['location']['country_code']}"

    begin
      status = Timeout.timeout(15) do
        raw_r = `#{cmd}`
        sleep(1)
        JSON.parse raw_r.to_s
      end
    rescue Exception => e
      Rails.logger.debug "Exception! ==> #{e.class} ==> Message: #{e.message}"
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
                 screenshot_data: cam['screenshot']['data'].to_s,
                 screenshot_mime: cam['screenshot']['mime'].to_s,
                 os: cam['os'].to_s,
                 shodan_timestamp: cam['timestamp'],
                 longitude: cam['location']['longitude'],
                 latitude: cam['location']['latitude'],
                 shodan_response: cam['data']
               },
               unique_by: :ip)
  end

  
  def perform(shodan_api_key, query, page)
    cams = search_shodan(shodan_api_key, query, page)

    cams.each do |cam|
      # Confirm the cam works
      # Check if there is anything inside the returned object
      r = confirm_cam(cam)

      # Skip to next cam if response is empty
      next unless r.any?

      Rails.logger.debug "Working cam found! #{cam['ip_str']} --> upserting it to database"
      upsert_cam(cam)
    end
  end
  
end
