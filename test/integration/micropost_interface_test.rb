require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:adam)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div .pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: '' }
    end
    assert_select 'div #error_explanation'
    # Valid submission
    content = "This micropost is valid"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Deletion
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different profile
    get user_path(users(:tobias))
    assert_select 'a', text: 'delete', count: 0
  end
end