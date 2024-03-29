class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.text :address
      t.references :account, index: true

      t.timestamps
    end
  end
end
