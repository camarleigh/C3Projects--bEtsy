class OrdersController < ApplicationController
  def index
<<<<<<< HEAD
    # a merchant can view all of their 'completed' orders
=======
    # a merchant can view all of their 'paid' and 'shipped' orders
    @merchant = Merchant.find(params[:merchant_id])
    # find only orders that are complete
    @orders = @merchant.orders.where(status: "complete").uniq.reverse
    @order_items = @merchant.order_items

    # @shipped_revenue = merchant.shipped?(true).sum("revenue")
    # @unshipped_revenue = merchant.shipped?(false).sum("revenue")
    # @shipped_count = merchant.shipped?(true).count
    # @unshipped_count = merchant.shipped?(false).count
  end

  def shipped
>>>>>>> e5867f60d2d4783827b7814ef182d8b996c9100b
    merchant = Merchant.find(params[:merchant_id])
    @order_items = merchant.order_items.where(shipped: true)
    @orders = merchant.orders.uniq.reverse

    @shipped_revenue = merchant.shipped?(true).sum("revenue")
    @unshipped_revenue = merchant.shipped?(false).sum("revenue")
    @shipped_count = merchant.shipped?(true).count
    @unshipped_count = merchant.shipped?(false).count
  end

  def unshipped
    merchant = Merchant.find(params[:merchant_id])
    @order_items = merchant.order_items.where(shipped: false)
    @orders = merchant.orders.uniq.reverse

    @shipped_revenue = merchant.shipped?(true).sum("revenue")
    @unshipped_revenue = merchant.shipped?(false).sum("revenue")
    @shipped_count = merchant.shipped?(true).count
    @unshipped_count = merchant.shipped?(false).count
  end

  def show
    # a merchant can view a particular order and all of its details (i.e. order_items/totals, etc.)
    @order = Order.find(params[:id])

    @order_items = Merchant.find(params[:merchant_id]).order_items

    @redacted_cc = redacted_cc(@order.credit_card)
  end

  def create
    # order gets created initially withOUT payment details (this happens at checkout)
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    @order.update(status: "complete")

    @order.order_items.each do |order_item|
      product = Product.find(order_item.product_id)
      previous_stock = product[:stock]
      ordered_stock = order_item.quantity

      product[:stock] = previous_stock.to_i - ordered_stock.to_i

      puts product[:stock]
    end
    
    session[:order_id] = nil # this clears the cart after you've checked out

    redirect_to order_confirmation_path(params[:id])
  end


  def destroy
    # if the customer 'clears' their cart ??? (need button for this)
  end

  def confirmation
    @order = Order.find(params[:order_id])
    @order_items = @order.order_items
    @total = get_total(@order_items)
    @customer_info = get_customer_info(@order)
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

  private

  def order_params
  params.require(:order).permit(:status, :name, :email, :street, :city, :state, :zip, :credit_card, :exp_date, :cvv, :billing_zip)
  end

  def redacted_cc(credit_card)
    credit_card.chars.last(4).join
  end
end
