class Account < ActiveRecord::Base
  validates :name, presence: true

  #concern User
    has_many :memberships
    has_many :users, through: :memberships
  #end

  #concern Invoice
    has_many :invoices

    def new_invoice(params = {})
      invoices.build(params)
    end

    def find_invoice(identifier)
      invoices.find(identifier)
    end

    def all_invoices
      invoices.order(:uid)
    end

    def next_invoice_uid
      if last_invoice
        last_invoice.next_uid
      else
        [Date.today.year, "001"].join("/")
      end
    end

    private def last_invoice
      all_invoices.last
    end
  #end
end
