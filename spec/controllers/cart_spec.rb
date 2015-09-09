require 'rails_helper'


RSpec.describe CartsController, type: :controller do
 describe "GET #show" do
   it "responds successfully with an HTTP 200 status code" do
     get :show

     expect(response).to be_success
     expect(response).to have_http_status(200)
   end

   # context "you can adjust cart item quantities in the cart #show view" do
   #   describe "calculates new totals in cart" do
   #     it "calculates total units" do
   #       current_order = Order.create
   #       current_order.order_items << OrderItem.
   #       @order_items = current_order.order_items

   #       calc_unit_total

   #       expect(@unit_total).to_eq 7
   #     end

       # it "calculates total dollars" do
       # end

     # end
   # end
 end
end
