require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
