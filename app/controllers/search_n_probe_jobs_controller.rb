class SearchNProbeJobsController < ApplicationController
  def new
  end

  def create
    shodan_api_key = job_params['shodan_api_key']
    query = job_params['query']
    page = job_params['page']

    SearchNProbeJob.perform_later(shodan_api_key, query, page)

    flash[:notice] = 'Looking for new working webcams in the background..'

    redirect_to root_path
  end

  private

  def job_params
    params.permit(%i[authenticity_token commit page query shodan_api_key])
  end
end
