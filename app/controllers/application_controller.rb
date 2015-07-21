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
    redirect_to login_path unless session[:merchant_id]
  end

  helper_method :current_order

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.create
    end
  end

end
