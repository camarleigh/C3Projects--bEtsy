class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_categories, :set_login_name

  def set_categories
   @categories = Category.all.order(:name)
  end

  def set_login_name
   @merchant = Merchant.find_by(id: session[:merchant_id])

   @merchant_name = @merchant ? @merchant.name : "Guest"
  end

  def require_login
    unless session[:merchant_id]

      flash[:login_error] = "You must be logged in to perform that action"

      redirect_to login_path
    end
  end

  def check_product_active_status
    product = Product.find(params[:id])

    unless product.active
      flash[:error] = "Sorry, this is not an active product."

      redirect_to root_path
    end
  end

  # def restrict_across_merchant
  #   unless session[:merchant_id] == params[:merchant_id]

  #     flash[:error] = "You may not view a page you do not have access to"

  #     redirect_to merchant_dashboard_path(session[:merchant_id])
  #   end
  # end

  # def verify_user_order
  #   if session[:order_id]

  # end

  helper_method :current_order
  helper_method :cart_units

  def current_order
    unless session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.create(status: "pending")
    end
  end

  def cart_units
    cart_units = 0

    current_order.order_items.each do |order_item|
      cart_units += order_item.quantity
    end

    return cart_units
  end

  # calculate order totals
  def calc_order_total
    @order_items = current_order.order_items

    @order_total = 0

    @order_items.each do |order_item|
      @order_total += order_item.revenue
    end

    return @order_total
  end
end
