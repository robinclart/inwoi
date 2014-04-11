class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.text :info
      t.text :terms_and_policies

      t.timestamps
    end
  end
end
