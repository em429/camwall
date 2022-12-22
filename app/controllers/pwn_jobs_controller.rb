class PwnJobsController < ApplicationController
  def start
    # Create a new pwn job, delayed_job works with the existing db, (not w/ extra Redis
    #   like Sidekiq) so it needs a persisted record in the database to work with
    @pwnjob = CamPwnJob.create

    # Always run the below async; it is set in the method definition.
    # We could just as well do `@pwnjob.delay.gather_cams` here, if we wanted to retain
    # non-async functionality as well
    @pwnjob.gather_cams

    flash[:notice] = 'Started looking for new working webcams in the background..'

    redirect_to root_path
  end
end
