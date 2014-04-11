require 'test_helper'

class SignupsTest < ActionDispatch::IntegrationTest
  test "that we can signup" do
    signup("Robin Clart", "robin@clart.be", "passw0rd")
    assert_match /\/accounts\/[0-9]+/, path
    assert_template "accounts/show"
    assert_select "[data-template=current-user-email]", "robin@clart.be"
  end

  test "that signup is unsuccessful if name is blank" do
    signup("", "robin@clart.be", "passw0rd")
    assert_select "[data-error=user.name]"
    assert_equal signup_path, path
    assert_template "signups/new"
  end

  test "that signup is unsuccessful if email is blank" do
    signup("Robin Clart", "", "passw0rd")
    assert_select "[data-error=user.email]"
    assert_equal signup_path, path
    assert_template "signups/new"
  end

  test "that signup is unsuccessful if password is blank" do
    signup("Robin Clart", "robin@clart.be", "")
    assert_select "[data-error=user.password]"
    assert_equal signup_path, path
    assert_template "signups/new"
  end
end
