require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:apple)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_url(id: @micropost), params: {micropost: { content: "Lorem Ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect for wrong micropost" do
    log_in_as(users(:adam))
    assert_no_difference 'Micropost.count' do
      delete micropost_path(id: microposts(:glass))
    end
  end
end
