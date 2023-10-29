class ShodanApiKeysController < ApplicationController
  def index
    @shodan_api_keys = ShodanApiKey.all
  end

  def show
    @shodan_api_key = ShodanApiKey.find(params[:id])
  end

  def new
    @shodan_api_key = ShodanApiKey.new
  end

  def create
    key = shodan_api_key_params['key']

    # TODO: move this logic to Model
    # Check key info
    shodan_client = Shodanz.client.new(key: key)
    info = shodan_client.info

    # Try to add key to db
    @shodan_api_key = ShodanApiKey.new(key: key,
                                       plan: info['plan'],
                                       scan_credit_limit: info['usage_limits']['scan_credits'],
                                       query_credit_limit: info['usage_limits']['query_credits'],
                                       monitored_ip_limit: info['usage_limits']['monitored_ips'])

    if @shodan_api_key.save
      redirect_to shodan_api_keys_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def shodan_api_key_params
    params.require(:shodan_api_key).permit(:key)
  end
end
