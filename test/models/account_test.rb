require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account_attrs = { name: "My account" }
  end

  test "that we can create an account" do
    account = Account.create(@account_attrs)
    assert_instance_of Account, account
    assert account.persisted?
  end

  test "that we cannot create an account without a name" do
    account = Account.create(@account_attrs.merge(name: nil))
    assert_instance_of Account, account
    refute account.valid?
    refute account.persisted?
  end

  test "that we can build a new invoice" do
    account = Account.create(@account_attrs)
    invoice = account.new_invoice
    assert_instance_of Invoice, account.new_invoice
    refute invoice.persisted?
  end

  test "that we cannot save a new invoice without uid" do
    account = Account.create(@account_attrs)
    invoice = account.new_invoice
    refute invoice.valid?
  end

  test "that we can save a new invoice" do
    account = Account.create(@account_attrs)
    invoice = account.new_invoice uid: "abc"
    assert invoice.valid?
  end

  test "that we can find an invoice" do
    account = Account.create(@account_attrs)
    invoice = account.new_invoice(uid: "XXXX/YYY")
    invoice.save
    assert invoice.persisted?
    found_invoice = account.find_invoice(invoice.id)
    assert_instance_of Invoice, found_invoice
    assert_equal invoice, found_invoice
  end

  test "that we can find all invoices" do
    account = Account.create(@account_attrs)
    invoice1 = account.new_invoice(uid: "XXXX/YYY1")
    invoice1.save
    invoice2 = account.new_invoice(uid: "XXXX/YYY2")
    invoice2.save
    assert account.all_invoices.to_a.include?(invoice1)
    assert account.all_invoices.to_a.include?(invoice2)
  end

  test "that we can get the next invoice uid" do
    account = Account.create(@account_attrs)
    invoice_uid = "2014/001"
    invoice = account.new_invoice(uid: invoice_uid)
    invoice.save
    assert_equal invoice_uid.next, account.next_invoice_uid
  end

  test "that we can get the next invoice uid when there's no invoice yet" do
    account = Account.create(@account_attrs)
    year = Date.today.year
    assert_equal "#{year}/001", account.next_invoice_uid
  end
end
