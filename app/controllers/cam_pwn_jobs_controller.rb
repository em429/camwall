class CamPwnJobsController < ApplicationController
  def index
    @cam_pwn_jobs = CamPwnJob.all.order(created_at: :desc).limit(25)
  end

  def new
    @cam_pwn_job = CamPwnJob.new
  end

  def create
    shodan_api_key = pwn_job_params['shodan_api_key']
    country = pwn_job_params['country']
    extra_filters = pwn_job_params['extra_filters']
    query = pwn_job_params['query']

    query = if country == 'GLOBAL'
              "#{query} #{extra_filters}"
            else
              "#{query} country:#{country} #{extra_filters}"
            end

    # Create a new pwn job, delayed_job works with the existing db, (not w/ extra redis
    #   like Sidekiq) so it needs a persisted record in the database to work with
    @cam_pwn_job = CamPwnJob.create(query: query)

    # Always run the below async; it is set in the method definition.
    # We could just as well do `@cam_pwn_job.delay.gather_cams` here, if we wanted to retain
    # non-async functionality as well
    @cam_pwn_job.gather_cams(shodan_api_key, query)

    flash[:notice] = 'Started looking for new working webcams in the background..'

    redirect_to root_path
  end

  private

  def pwn_job_params
    params.require(:cam_pwn_job).permit(%i[query shodan_api_key country extra_filters])
  end
end