require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  def setup
    User.signup(
      name: "Robin",
      email: "robin@clart.be",
      password: "passw0rd"
    )
  end

  test "that we can login" do
    login("robin@clart.be", "passw0rd")
    assert_match /\/accounts\/[0-9]+/, path
    assert_template "accounts/show"
    assert_instance_of User, assigns(:current_user)
  end

  test "that we cannot login with the wrong password" do
    login("robin@clart.be", "12345678")
    assert_equal login_path, path
    assert_template "sessions/new"
    assert_nil assigns(:current_user)
  end

  test "that we cannot login with the wrong email" do
    login("john@example.com", "passw0rd")
    assert_equal login_path, path
    assert_template "sessions/new"
    assert_nil assigns(:current_user)
  end

  test "that we can logout" do
    login("robin@clart.be", "passw0rd")
    delete login_path
    follow_redirect!
    assert_nil assigns(:current_user)
  end
end
