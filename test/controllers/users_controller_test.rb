require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:adam)
    @other_user = users(:tobias)
  end

  test "should redirect index when not logged in" do
    get users_path
    # assert_redirected_to login_url
  end

  test "should get /new and Sign Up title" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | Chirper"
  end

  test "should redirect edit when not logged_in" do
    get edit_user_url id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged_in" do
    patch update_path id: @user, params: { user:
                                             { name: @user.name,
                                               email: @user.email
                                              }
                                         }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_url id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch update_path id: @user, params: { user:
                                             { name: @user.name,
                                               email: @user.email
                                              }
                                         }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when user not logged in" do
    assert_no_difference 'User.count' do
      delete user_url(@user)
    end
    assert_redirected_to '/login'
  end

  test "should redirect destroy when user not an admin" do
  end

end
