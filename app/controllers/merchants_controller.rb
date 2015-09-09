class MerchantsController < ApplicationController
  before_action :require_login, only: [:dashboard]

  def show
    @merchant = Merchant.find(params[:id])

    @merchant_products = @merchant.products.where(active: true)

    render :show
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.create(merchant_params)

    if @merchant.save
      session[:merchant_id] = @merchant.id
      redirect_to root_path
    else
      flash.now[:error] = "Try again, account was not created."
      render :new
    end
  end

  def dashboard
    if session[:merchant_id] == params[:merchant_id].to_i
    # may change the params depending on sessions
      @merchant = Merchant.find(params[:merchant_id])

      @products = @merchant.products

      @order_items = @merchant.order_items

      @revenue = 0

      @order_items.each do |order_item|
        @revenue += order_item.revenue
      end

     else
      flash[:error] = "You do not have access to that merchant's dashboard"

      redirect_to merchant_dashboard_path(session[:merchant_id])
    end
  end

#________________________________________________________________________________
  private

  def merchant_params
    params.require(:merchant).permit(:name, :email, :password, :password_confirmation)
  end
end
