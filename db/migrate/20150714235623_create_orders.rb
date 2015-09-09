class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :email
      t.string :street
      t.string :city
      t.string :state
      t.integer :zip
      t.string :credit_card
      t.integer :exp_date
      t.integer :cvv
      t.integer :billing_zip

      t.timestamps null: false
    end
  end
end
