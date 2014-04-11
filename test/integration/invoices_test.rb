require 'test_helper'

class InvoicesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.signup(
      name: "Robin",
      email: "robin@clart.be",
      password: "passw0rd"
    )
    @account = @user.accounts.first
  end

  test "that we can create an invoice" do
    login("robin@clart.be", "passw0rd")
    get account_path(@account)
    refute redirect?
    click_link new_account_invoice_path(@account)
    assert_form_for account_invoices_path(@account)
    assert_select "input#invoice_uid"
    post account_invoices_path(@account), invoice: { uid: "XXXX/YYY" }
    follow_redirect!
    assert_template "invoices/edit"
  end

  test "that we cannot create an invoice without uid" do
    login("robin@clart.be", "passw0rd")
    get account_path(@account)
    refute redirect?
    click_link new_account_invoice_path(@account)
    assert_form_for account_invoices_path(@account)
    assert_select "input#invoice_uid"
    post account_invoices_path(@account), invoice: { uid: "" }
    assert_template "invoices/new"
  end

  test "that we can update an invoice" do
    login("robin@clart.be", "passw0rd")
    invoice = @account.new_invoice(uid: "XXXX/YYY")
    invoice.save
    get account_path(@account)
    click_link edit_account_invoice_path(@account, invoice)
    assert_select "input#invoice_date"
    assert_select "textarea#invoice_additional_references"
    assert_select "input#invoice_account_name"
    assert_select "input#invoice_account_info"
    assert_select "input#invoice_customer_name"
    assert_select "textarea#invoice_customer_address"
    assert_select "input#invoice_project_name"
    assert_select "textarea#invoice_project_description"
    assert_select "textarea#invoice_account_terms_and_policies"
    invoice_params = {
      date: "2014-01-01",
      account_name: @account.name,
      account_info: @account.info,
      customer_name: "John Doe",
      customer_address: "1 Main street\nCity 00000",
      project_name: "Website Design",
      project_description: ""
    }
    patch account_invoice_path(@account, invoice), invoice: invoice_params
    follow_redirect!
    assert_template "invoices/index"
    assert_equal invoice, Invoice.where(invoice_params).first
  end

  test "that we cannot update an invoice" do
    login("robin@clart.be", "passw0rd")
    invoice = @account.new_invoice(uid: "XXXX/YYY")
    invoice.save
    get account_path(@account)
    click_link edit_account_invoice_path(@account, invoice)
    assert_fields_for :invoice, date: :input,
                                additional_references: :textarea,
                                account_name: :input,
                                account_info: :input,
                                customer_name: :input,
                                customer_address: :textarea,
                                project_name: :input,
                                project_description: :textarea,
                                account_terms_and_policies: :textarea
    invoice_params = {
      uid: "",
      date: "2014-01-01",
      account_name: @account.name,
      account_info: @account.info,
      customer_name: "John Doe",
      customer_address: "1 Main street\nCity 00000",
      project_name: "Website Design",
      project_description: ""
    }
    patch account_invoice_path(@account, invoice), invoice: invoice_params
    assert_template "invoices/edit"
  end
end
