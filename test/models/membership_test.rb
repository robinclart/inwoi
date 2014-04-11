require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test "that membership respond to account" do
    assert Membership.new.respond_to?(:account)
    assert Membership.new.respond_to?(:account=)
  end

  test "that membership respond to user" do
    assert Membership.new.respond_to?(:user)
    assert Membership.new.respond_to?(:user=)
  end
end
