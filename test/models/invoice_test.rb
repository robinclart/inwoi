require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test "that we can save" do
    invoice = Invoice.new uid: "a"
    invoice.save
    assert invoice.persisted?
  end

  test "that we cannot save without a uid" do
    invoice = Invoice.new
    invoice.save
    refute invoice.persisted?
  end

  test "that invoice respond to account" do
    assert Invoice.new.respond_to?(:account)
    assert Invoice.new.respond_to?(:account=)
  end

  test "that we can get the next uid" do
    invoice = Invoice.new uid: "a"
    assert "a".next, invoice.next_uid
  end

  test "that we cannot get the next uid if uid is nil" do
    invoice = Invoice.new
    assert_equal nil, invoice.next_uid
  end

  test "that we cannot get the next uid if uid is blank" do
    invoice = Invoice.new uid: ""
    assert_equal nil, invoice.next_uid
  end
end
