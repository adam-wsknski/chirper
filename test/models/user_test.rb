require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Zenon Benon", email: "zenon@wp.pl", password: "hasloo", password_confirmation: "hasloo")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 53
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 153
    assert_not @user.valid?
  end

  test "email format should be in correct form" do
    valid_addresses = %w[user@example.com USER@FOO.CoM PL_AN-Ger@pol.com
                        first.last@foo.jp alice+bob.@ali.cn]
    valid_addresses.each do |valid|
      @user.email = valid
      assert @user.valid?
    end
  end

  test "email validation should reject incorrect email formats" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@exampl.
                          foo@boo_boo.org foo@boo+bib.obi]

    invalid_addresses.each do |invalid|
      @user.email = invalid
      assert_not @user.valid?
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "pass should have minimal length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticate? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "test text")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
