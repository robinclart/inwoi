require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user_attrs = {
      name: "Robin",
      email: "robin@clart.be",
      password: "passw0rd"
    }
  end

  test "that user respond to accounts" do
    assert User.new.respond_to?(:accounts)
  end

  test "that user respond to memberships" do
    assert User.new.respond_to?(:memberships)
  end

  test "that when a user signup it creates a new user" do
    user = User.signup(@user_attrs)
    assert user
    assert_instance_of User, user
  end

  test "that a user cannot signup without an email" do
    user = User.signup(@user_attrs.merge(email: nil))
    refute user.persisted?
    refute user.valid?
  end

  test "that a user cannot signup without a password" do
    user = User.signup(@user_attrs.merge(password: nil))
    refute user.persisted?
    refute user.valid?
  end

  test "that when a user signup it creates a new account for the user" do
    user = User.signup(@user_attrs)
    assert_equal 1, user.memberships.count
    assert_equal 1, user.accounts.count
    assert_equal user.memberships.first.account, user.accounts.first
  end

  test "that when a user signup it creates a new user associated to a new account with the same name" do
    user = User.signup(@user_attrs)
    assert_equal user.name, user.accounts.first.name
  end

  test "that when a user signup it creates a new user associated to a new account with another name" do
    account_name = "Inwoi Inc."
    user = User.signup(@user_attrs.merge(account_name: account_name))
    assert_equal account_name, user.accounts.first.name
  end

  test "that two users can't have the same email" do
    user1 = User.signup(@user_attrs)
    user2 = User.signup(@user_attrs)
    assert user1.persisted?, "This user should be persisted"
    refute user2.persisted?, "This user should not be persisted"
    assert user2.errors.include?(:email), "The errors should include an error about email"
  end
end
