class SessionsController < ApplicationController

  def create
    @merchant = Merchant.find_by(email: params[:session][:email])

    if @merchant && @merchant.authenticate(params[:session][:password])
      session[:merchant_id] = @merchant.id
      redirect_to root_path
    else
      flash.now[:login_error] = "Try again, password incorrect."
      render :new
    end
  end

  def destroy
    session[:merchant_id] = nil

    if session[:order_id]
      order = Order.find(session[:order_id])
      session[:order_id] = nil

      if order.status == "pending"
        order.destroy
      end
    end

    redirect_to root_path
  end
end
