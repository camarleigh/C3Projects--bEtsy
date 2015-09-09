require 'shipping_client'

class OrdersController < ApplicationController
  before_action :require_login, except: [:edit, :update, :confirmation, :shipping_address_form, :shipping_estimates, :select_shipping_method]

  def index
    if session[:merchant_id] == params[:merchant_id].to_i
      @merchant = Merchant.find(params[:merchant_id])

      # find only orders that are complete
      @orders = @merchant.orders.where(status: "complete").uniq.reverse

      @order_items = find_relevant_order_items(@orders, @merchant.id)

      # from completed orders, find order items that belong to this merchant
      # sum up the revenue from these order items
      @shipped_revenue = revenue(@order_items, true)
      @unshipped_revenue = revenue(@order_items, false)
      @shipped_count = count_items(@order_items, true)
      @unshipped_count = count_items(@order_items, false)

    else
      flash[:error] = "You do not have access to that merchant's orders."

      redirect_to merchant_dashboard_path(session[:merchant_id])
    end
  end

  def shipped
    @merchant = Merchant.find(params[:merchant_id])
    @orders = @merchant.orders.where(status: "complete").uniq.reverse
    @order_items = find_relevant_order_items(@orders, @merchant.id)
    @order_items_shipped = shipped?(@order_items, true)

    @shipped_orders = find_orders_by_status(@orders, true, @merchant.id)

    @shipped_revenue = revenue(@order_items, true)
    @unshipped_revenue = revenue(@order_items, false)
    @shipped_count = count_items(@order_items, true)
    @unshipped_count = count_items(@order_items, false)

  end

  def unshipped
    @merchant = Merchant.find(params[:merchant_id])
    @orders = @merchant.orders.where(status: "complete").uniq.reverse
    @order_items = find_relevant_order_items(@orders, @merchant.id)
    @order_items_unshipped = shipped?(@order_items, false)

    @unshipped_orders = find_orders_by_status(@orders, false, @merchant.id)

    @shipped_revenue = revenue(@order_items, true)
    @unshipped_revenue = revenue(@order_items, false)
    @shipped_count = count_items(@order_items, true)
    @unshipped_count = count_items(@order_items, false)
  end

  def show
    # a merchant can view a particular order and all of its details (i.e. order_items/totals, etc.)
    @order = Order.find(params[:id])

    @order_items = Merchant.find(params[:merchant_id]).order_items

    @redacted_cc = redacted_cc(@order.credit_card)
  end

  def edit
     @order_items = current_order.order_items
     @order_total = calc_order_total + (session[:shipping_cost].to_f/100)
    # every time a new order_item is added/removed from the cart
    # when the customer adds their payment details
    # params[:id] is the order.id
    if session[:order_id] == params[:id].to_i
      @order = Order.find(params[:id])
    else
      flash[:error] = "You do not have access to that order."

      redirect_to root_path
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    @order.update(status: "complete")

    @order.order_items.each do |order_item|
      product = Product.find(order_item.product_id)
      previous_stock = product[:stock]
      ordered_stock = order_item.quantity

      new_stock = previous_stock.to_i - ordered_stock.to_i
      product.update(stock: new_stock)

    end

    #sets shipping info into variables to send to Shipping API
    shipping_method = session[:shipping_method]
    shipping_cost = session[:shipping_cost]

    ShippingClient.send_shipping_info(params[:id], shipping_method, shipping_cost)

    session[:order_id] = nil # this clears the cart and shipping choices after you've checked out

    redirect_to order_confirmation_path(params[:id])
  end

  def confirmation

    @order = Order.find(params[:order_id])
    @order_items = @order.order_items
    @total = get_total(@order_items)
    @customer_info = get_customer_info(@order)
    @shipping_cost = session[:shipping_cost].to_f
    @shipping_method =  session[:shipping_method]
    @shipping_estimate = session[:shipping_estimate]

    session[:shipping_method] = nil
    session[:shipping_cost] = nil
    session[:shipping_estimate] = nil
  end

  def get_total(order_items)
    order_items.inject(0) do |sum, i|
      sum + i.revenue
    end
  end

  def get_customer_info(order)
    customer_info = []

    customer_info.push(order.name, order.email, order.street, order.city, order.state, order.zip)
  end

  def shipped?(order_items, bool)
    final_items = []
    order_items.each do |order_item|
      if order_item.shipped == bool
        final_items.push(order_item)
      end
    end
    return final_items
  end

  def count_items(order_items, bool)
    count = 0
    order_items.each do |order_item|
      if order_item.shipped == bool
        count += order_item.quantity
      end
    end
    return count
  end

  def find_relevant_order_items(orders, merchant_id)
    relevant_order_items = []
    orders.each do |order|
      all_order_items = order.order_items
      order_items = all_order_items.where(merchant_id: merchant_id)
      relevant_order_items.push(order_items)
    end
    return relevant_order_items.flatten
  end

  def find_orders_by_status(orders, bool, merchant_id)
    relevant_orders = []
    orders.each do |order|
      # order_items include order_items that don't belong to the merchant
      all_order_items = find_relevant_order_items([order], merchant_id)
      all_order_items.each do |order_item|
        if order_item.shipped == bool
          relevant_orders.push(order_item.order)
        end
      end
    end
    return relevant_orders.uniq
  end

  def revenue(order_items, bool)
    revenue = 0
    order_items.each do |order_item|
      if order_item.shipped == bool
        revenue += order_item.revenue
      end
    end
    return revenue
  end

# SHIPPING API METHODS ---------------------------------------------------------
  def shipping_address_form
    @states = %w(AL AK AZ AR CA CO CT DC DE FL GA HI ID IL IN IA KS KY LA ME MA MI MN MO MS MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY)
  end

  def shipping_estimates
    products = Order.get_products_information_for_shipping_api(params[:order_id])
    begin
      status = Timeout::timeout(10) {
        @response = ShippingClient.find_shipping_rates(params, products) }
        if @response.code == 400
          flash[:error] = "Please enter a valid address."
          redirect_to order_shipping_address_form_path
        end
    rescue Timeout::Error
      redirect_to :back, :flash => { :error => "Action timed out. Please try again." }
    end
  end

  # sets shipping choice into session to carry over to checkout
  def select_shipping_method
    session[:shipping_method] = params[:delivery_method]
    session[:shipping_cost] = params[:shipping_cost]
    session[:shipping_estimate] = params[:shipping_estimate]

    redirect_to edit_order_path(current_order.id)
  end



############################################################
  private

  def order_params
  params.require(:order).permit(:status, :name, :email, :street, :city, :state, :zip, :credit_card, :exp_date, :cvv, :billing_zip)
  end

  def redacted_cc(credit_card)
    credit_card.chars.last(4).join
  end
end
