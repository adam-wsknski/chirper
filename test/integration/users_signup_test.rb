require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup info" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user:
                                 { name: "",
                                   email: "user@invalid.pl",
                                   password: "lokos",
                                   password_confirmation: "locos"
                                  }
                               }
    end
    assert_template 'users/new'
  end

  test "valid signup info" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user:
                                 { name: "Examp;",
                                   email: "user@valid.pl",
                                   password: "locos12",
                                   password_confirmation: "locos12"
                                  }
                               }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activatioin
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
