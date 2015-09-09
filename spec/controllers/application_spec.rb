require 'rails_helper'
# RSpec.describe ApplicationController, type: :controller do
#   # describe "GET #index" do
#   #   it "responds successfully with an HTTP 200 status code" do
#   #     get :index

#   #     expect(response).to be_success
#   #     expect(response).to have_http_status(200)
#   #   end
#   # end
# end



  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # before_filter :set_categories, :set_login_name

  #  def set_categories
  #    @categories = Category.all.order(:name)
  #  end

  #  def set_login_name
  #    @merchant = Merchant.find_by(id: session[:merchant_id])
  #    @merchant_name = @merchant ? @merchant.name : "Guest"
  #  end

  # def require_login
  #   redirect_to login_path unless session[:merchant_id]
  # end