class SearchNProbeJobsController < ApplicationController
  def new
  end

  def create
    shodan_api_key = job_params['shodan_api_key']
    country = job_params['country']
    extra_filters = job_params['extra_filters']
    query = job_params['query']
    page = job_params['page']

    # TODO: move this logic to the job
    query = if country == 'GLOBAL'
              "#{query} #{extra_filters}"
            else
              "#{query} country:#{country} #{extra_filters}"
            end

    SearchNProbeJob.perform_later(shodan_api_key, query, page)

    flash[:notice] = 'Looking for new working webcams in the background..'

    redirect_to root_path
  end

  private

  def job_params
    params.permit(%i[authenticity_token commit page query shodan_api_key country extra_filters])
  end
end
