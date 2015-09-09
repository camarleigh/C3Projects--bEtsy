class Order < ActiveRecord::Base
  # Associations
  has_many :order_items
  has_many :products, :through => :order_items

  def self.get_products_information_for_shipping_api(order_id)
    order_items = Order.find(order_id).order_items
    products = order_items.map do |item|
      {
        weight: item.product.weight,
        length: item.product.length,
        width: item.product.width
      }
    end

    return products
  end
end
