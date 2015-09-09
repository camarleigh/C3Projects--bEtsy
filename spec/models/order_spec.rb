require 'rails_helper'

RSpec.describe Order, type: :model do 

  describe "model validations" do
    # it "requires a name all the time" do
    #   order = Order.new

    #   expect(order).to_not be_valid
    #   expect(order.errors.keys).to include(:name)
    # end

    it "has many order_items and many products (through order_items)" do
      expect(Order.reflect_on_association(:order_items).macro).to eq(:has_many)
      expect(Order.reflect_on_association(:products).macro).to eq(:has_many)
    end

  end

end
