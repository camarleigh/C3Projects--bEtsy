class HomeController < ApplicationController
  def index
    @active_products = Product.where(active: true)
    @product_first_row = @active_products.first(3)
    @product_second_row = @active_products.last(3)
  end
end
