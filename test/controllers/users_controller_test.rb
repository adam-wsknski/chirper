require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should get /new and Sign Up title" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | Chirper"
  end

end
