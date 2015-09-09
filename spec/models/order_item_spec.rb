require 'rails_helper'

RSpec.describe OrderItem, type: :model do 

  describe "model validations" do
    it "requires a product_id, order_id, revenue, and quantity all the time" do
      order_item = OrderItem.new

      expect(order_item).to_not be_valid
      expect(order_item.errors.keys).to include(:product_id, :order_id, :revenue, :quantity)
    end

    it "belongs to an order, a product and a merchant" do
      expect(OrderItem.reflect_on_association(:order).macro).to eq(:belongs_to)
      expect(OrderItem.reflect_on_association(:product).macro).to eq(:belongs_to)
      expect(OrderItem.reflect_on_association(:merchant).macro).to eq(:belongs_to)
    end
  end

end
