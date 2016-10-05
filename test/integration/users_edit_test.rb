require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:adam)
  end

  test "Unsucessful profile edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user:
                                       { name: "",
                                         email: "user@invalid.pl",
                                         password: "lokos",
                                         password_confirmation: "locos"
                                        }
                                     }
  assert_template 'users/edit'
  end

  test "sucessful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "foo_foo"
    email = "user@valid.pl"
    patch user_path(@user), params: { user:
                                       { name: name,
                                         email: email,
                                         password: "",
                                         password_confirmation: ""
                                        }
                                     }
    assert_redirected_to(@user)
    assert_not flash.empty?
    @user.reload
    assert_equal @user.name, "foo_foo"
    assert_equal @user.email, "user@valid.pl"
  end
end
