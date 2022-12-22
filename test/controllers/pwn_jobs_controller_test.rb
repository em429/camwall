require "test_helper"

class PwnJobsControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get pwn_jobs_start_url
    assert_response :success
  end
end
