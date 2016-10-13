require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:adam)
    @micropost = @user.microposts.build(content: "Jestem nowym czirpem!")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "COntent should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "Content should be not longer than 140 chars" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "Microposts should be ordered from most recent to oldest" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
