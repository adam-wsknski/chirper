require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "Home | Chirper"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Chirper"
  end

  test "should get about page" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Chirper"
  end

end
