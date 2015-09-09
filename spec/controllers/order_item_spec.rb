require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  # describe "DELETE #destroy" do
    
  #   it "deletes an order_item" do
  #     current_order = Order.new
  #     order_item = OrderItem.new(product_id: 2, revenue: 12.50, quantity: 1, order_id: current_order.id)

  #     puts order_item.valid?
  #     puts order_item.id

  #     delete :destroy, id: 

  #     expect(order_item).to_not be_valid
  #   end
  
  # end

  # describe "POST #create" do
  #   let(:order_item_params) do
  #     {
  #       order_item: {
  #         product_id: 2,
  #         order_id: current_order.id,
  #         reveneue: 14.00,
  #         quantity: 1
  #       }
  #     }
  #   end

  #   it "creates a new order_item" do
  #     # make a 'create' scenario that would trigger this... 
  #     # current_order = Order.create(status: "pending")

  #     old_order_item = OrderItem.last

  #     post :create, order_item_params

  #     new_order_item = OrderItem.last

  #     expect(new_order_item).to_not eq(old_order_item)
  #   end
  # end

  describe "PATCH #mark_shipped" do
    it "marks things as shipped" do
      order_item = OrderItem.find(5)
      merchant_id = order_item.merchant_id

      patch :mark_shipped, merchant_id: merchant_id, id: order_item.id

      order_item.reload

      expect(order_item.shipped).to eq true
    end
  end

end
