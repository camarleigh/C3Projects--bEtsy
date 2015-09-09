class AddsPackageColumnToProductModel < ActiveRecord::Migration
  def self.up
    add_column :products, :length, :integer
    add_column :products, :width, :integer
    add_column :products, :weight, :integer

    Product.all.each do |product|
      product.length = 1
      product.width = 1
      product.weight = 1

      product.save!
    end

    change_column :products, :length, :integer, null: false
    change_column :products, :width, :integer, null: false
    change_column :products, :weight, :integer, null: false
  end

  def self.down
    remove_column :products, :length
    remove_column :products, :width
    remove_column :products, :weight
  end
end
