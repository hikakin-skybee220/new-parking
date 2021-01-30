require 'test_helper'

class ParkingControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get parking_start_url
    assert_response :success
  end

end
