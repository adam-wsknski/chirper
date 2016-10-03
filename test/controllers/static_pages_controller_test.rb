require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | Chirper"
  end

  test "should get about page" do
    get about_path
    assert_response :success
    assert_select "title", "About | Chirper"
  end

  test "should get contact page" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | Chirper"
  end

end
