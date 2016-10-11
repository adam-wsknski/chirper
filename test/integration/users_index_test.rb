require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:adam)
    @not_admin = users(:tobias)
  end

  test "index as a admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select "div", :class => 'pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a', :href => users_path(user), text: user.name
      assert_select 'a', :href => users_path(user), text: 'delete',
                                                      method: :delete
    end
    assert_difference 'User.count', -1 do
      delete user_path(@not_admin)
    end
  end



  test "index as non-admin" do
    log_in_as(@not_admin)
    get users_path
    assert_select 'a', :text => 'delete', count: 0
  end

end
