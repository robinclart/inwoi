class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :uid
      t.datetime :date
      t.text :additional_references
      t.string :account_name
      t.text :account_info
      t.string :customer_name
      t.text :customer_address
      t.string :project_name
      t.text :project_description
      t.integer :total
      t.text :account_terms_and_policies
      t.references :account, index: true
      t.references :customer, index: true

      t.timestamps
    end
  end
end
