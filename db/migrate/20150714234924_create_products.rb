class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :price
      t.integer :stock
      t.boolean :active
      t.string :photo_url
      t.integer :merchant_id

      t.timestamps null: false
    end
  end
end
