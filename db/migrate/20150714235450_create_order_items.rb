class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.float :revenue
      t.boolean :shipped
      t.integer :merchant_id

      t.timestamps null: false
    end
  end
end
