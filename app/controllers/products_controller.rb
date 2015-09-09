class ProductsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :check_product_active_status, only: [:show]

  def index
    # a guest or merchant can view all products with their details
    # @products = Product.all
    @products = Product.where(active: true)

    @order_item = current_order.order_items.new
    # a guest or merchant can view all products by category
  end

  def show
    # product detail page
    # some conditional visuals based on if you're logged in or not (view-things)
      # merchants can't buy their own products (i.e. no 'add to cart' button for them)
      # merchants can't leave reviews for their own products
      # if instock? == false, you can't add it to the cart
    @product = Product.find(params[:id])
    @order_item = current_order.order_items.new
    @review = Review.new

    @reviews = @product.reviews

    @average = average_rating(@reviews)

    existing_cart_product = current_order.order_items.select {|item| item.product_id == @product.id }

    if existing_cart_product.length == 0
      @additional_stock_available = @product.stock.to_i
    elsif existing_cart_product.length > 0
      calc_additional_stock_available(existing_cart_product[0])
    end
  end

  def calc_additional_stock_available(existing_cart_product)
    cart_product_units = existing_cart_product.quantity
    @additional_stock_available = @product.stock.to_i - cart_product_units.to_i

    return @additional_stock_available
  end

  def new
    # a merchant can create a new product using a form
    # (nested routing bc the prod is associated with that merchant only)
    # takes you to a form page
    if session[:merchant_id] == params[:merchant_id].to_i
      @product = Product.new

      @categories = Category.all.order(:name)
    else
      flash[:error] = "You do not have access to that merchant's products"

      redirect_to merchant_dashboard_path(session[:merchant_id])
    end
  end

  def create
    # submits the form to save the new product to the db
    # redirects you to the merchant dashboard page
    @product = Product.create(product_params)

    if @product.save
      categories_update(@product)

      if params[:review]
        @review = Review.create(review_params)
      end
      redirect_to merchant_dashboard_path(params[:merchant_id])
    else
      flash[:error] = "Please enter valid values"
      redirect_to :back
    end
  end

  def edit
    # a merchant can edit details about a product using a form
    # note: changing the price of a product will NOT change the price of the order_item (intentionally)
    # takes you to a form page
    if session[:merchant_id] == params[:merchant_id].to_i
      @product = Product.find(params[:id])

      @categories = Category.all.order(:name)
    else
      flash[:error] = "You do not have access to that merchant's products"

      redirect_to merchant_dashboard_path(session[:merchant_id])
    end
  end

  def update
    # submits the form to save changes to the product details
    # redirects you to the merchant dashboard page
    @product = Product.find(params[:id])

    if params[:merchant_id]
      @product.update(product_params)

      categories_update(@product)

      redirect_to merchant_dashboard_path(params[:merchant_id])
    else
      active_update(@product)

      redirect_to(:back)
    end

  end

  def destroy
    # a merchant can delete a product from their dashboard page by clicking the 'x' next to the product
    # does it right on the same screen, doesn't take you somewhere else to do it
    # redirects you to the merchant dashboard page when done
    @product = Product.find(params[:id])

    @product.destroy

    redirect_to(:back)
  end

  def categories_update(product)
    product.categories.destroy_all

    input_categories = params[:product][:categories]

    input_categories.each do |input|
      if input != ""
        product.categories << Category.find(input)
      end
    end
  end

  def active_update(product)
    product.active ? product.update(active: false) : product.update(active: true)
  end

  def average_rating(reviews)
    reviews.inject(0) { |sum, r| sum + r.rating}.to_f / reviews.size
  end

#--------------------------------------------------------------------------------
  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :active, :photo_url, :merchant_id, :categories, :length, :width, :weight)
  end

  def review_params
    params.require(:review).permit(:content, :rating, :product_id)
  end
end
