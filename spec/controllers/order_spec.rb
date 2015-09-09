require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe "GET #index" do
    # render_views
    #
    # it "renders the index template" do
    #   get :index, {merchant_id: 1}
    #   expect(response).to render_template(:index)
    # end

    it "route to correct controller and action" do
      expect(:get => "/merchants/1/orders").to route_to(:controller => "orders",
                                                        :action => "index",
                                                        :merchant_id => "1")
    end
  end

  describe "GET #shipped" do
    # render_views
    #
    # it "renders the shipped view" do
    #   get :shipped, {:merchant_id => 1}
    #   expect(response).to render_template(:partial => "_orders")
    # end

    it "routes to correct controller and action" do
      expect(:get => "/merchant/1/orders/shipped").to route_to(:controller => "orders",
                                                               :action => "shipped",
                                                               :merchant_id => "1")
    end
  end

  describe "GET #unshipped" do
    it "routes to correct controller and action" do
      expect(:get => "/merchant/1/orders/unshipped").to route_to(:controller => "orders",
                                                               :action => "unshipped",
                                                               :merchant_id => "1")
    end
  end

  describe "GET #show" do
    it "routes to correct controller and action" do
      expect(:get => "/orders/1").to route_to(:controller => "orders",
                                              :action => "show",
                                              :id => "1")
    end
  end

  describe "GET #confirmation" do
    it "routes to correct controller and action" do
      expect(:get => "/orders/1/confirmation").to route_to(:controller => "orders",
                                                           :action => "confirmation",
                                                           :order_id => "1")
    end
  end
end
