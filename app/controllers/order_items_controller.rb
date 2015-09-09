class OrderItemsController < ApplicationController
  before_action :check_for_duplicate_product, only: [:create]

  def create
    @order = current_order

    calc_revenue

    @order_item = @order.order_items.create(order_item_params)

    session[:order_id] = @order.id

    redirect_to '/cart'
  end

  def check_for_duplicate_product
    order = current_order
    @product_id = params[:order_item][:product_id]
    matching_product = order.order_items.select {|order_item| order_item.product_id == @product_id.to_i}

    if matching_product.length > 0
      update_existing_cart_product(matching_product[0])
    end
  end

  def update_existing_cart_product(matching_product)
    current_quantity = matching_product.quantity
    add_quantity = params[:order_item][:quantity]
    params[:order_item][:quantity] = current_quantity.to_i + add_quantity.to_i

    calc_revenue

    matching_product.update_attributes(order_item_params)

    redirect_to(:back)

    rescue 
      redirect_to root_path
  end

  def update
    @order_item = OrderItem.find(params[:id])

    calc_revenue

    @order_item.update_attributes(order_item_params)

    redirect_to(:back)

    rescue 
      redirect_to root_path
  end

  def calc_revenue
    product = Product.find(params[:order_item][:product_id])
    params[:order_item][:revenue] = params[:order_item][:quantity].to_i * product.price
  end

  def destroy
    # if a customer decreases the qty number for a product in the cart view (i.e. 3 > 1 sweater)
    # if a customer clicks an 'x' in the cart view to remove all units of that product??
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items

    redirect_to(:back)

    rescue 
      redirect_to root_path
  end

  def mark_shipped
    order_item = OrderItem.find(params[:id])
    order_item.update(shipped: true)

    redirect_to(:back)

    rescue 
      redirect_to root_path
  end

###############################################
  private

  def order_item_params
    params.require(:order_item).permit(:product_id, :order_id, :revenue, :quantity, :shipped, :merchant_id)
  end

end
