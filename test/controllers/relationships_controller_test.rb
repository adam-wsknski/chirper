require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  test "should redirect create when user not logged in" do
    assert_no_difference 'Relationship.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when user not logged in" do
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    assert_redirected_to login_url
  end
end
