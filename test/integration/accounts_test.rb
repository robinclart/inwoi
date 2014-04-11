require 'test_helper'

class AccountsTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.signup(
      name: "Robin",
      email: "robin@clart.be",
      password: "passw0rd"
    )
    @account = @user.accounts.first
  end

  test "that we can visit an account path" do
    login "robin@clart.be", "passw0rd"
    get account_path(@account)
    assert_template "accounts/show"
    assert_select "[data-template='account.name']", @account.name
  end

  test "that we cannot visit an account if not logged in" do
    get account_path(@account)
    assert redirect?
  end

  test "that we can update an account" do
    login "robin@clart.be", "passw0rd"
    get account_path(@account)
    click_link edit_account_path(@account)
    assert_form_for account_path(@account)
    assert_select "input#account_name"
    assert_select "textarea#account_info"
    assert_select "textarea#account_terms_and_policies"
    patch account_path(@account), account: { name: "My new name" }
    follow_redirect!
    assert_response :success
    assert_equal account_path(@account), path
    assert_template "accounts/show"
    assert_select "[data-template='account.name']", "My new name"
  end

  test "that we cannot update an account if the name is blank" do
    login "robin@clart.be", "passw0rd"
    get edit_account_path(@account)
    patch account_path(@account), account: { name: "" }
    refute redirect?
    refute assigns(:account).valid?
    assert_select "[data-error='account.name']"
    get account_path(@account)
    assert_select "[data-template='account.name']", "Robin"
  end
end
