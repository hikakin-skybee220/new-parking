require 'test_helper'

class PasswordControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get password_new_url
    assert_response :success
  end

  test "should get edit" do
    get password_edit_url
    assert_response :success
  end

end
