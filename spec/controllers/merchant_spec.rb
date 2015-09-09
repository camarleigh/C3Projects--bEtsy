require 'rails_helper'
RSpec.describe MerchantsController, type: :controller do
  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do
       get :show, {id: 1}

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new

    expect(response).to be_success
    expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
  it "responds successfully with an HTTP 200 status code" do
    #get :create, {merchant: {name: "Pam", email: "pam@email.com", password: "sexiboys", password_confirmation: "sexiboys"}}

    expect(response).to be_success
    expect(response).to have_http_status(200)
    #expect(response).to render_template(:index)
  end
end

  describe "GET #dashboard" do
    it "responds successfully with an HTTP 200 status code" do
      #get :dashboard, {merchant_id: 1}

      expect(response).to be_success
      expect(response).to have_http_status(200)
      end
    end


let(:merchant) { Merchant.find(3) }

  describe "merchant attributes" do
    it "knows the merchant's name" do
      expect(merchant.name).to eq("Material Girl")
    end

    it "knows the merchant's email" do
      expect(merchant.email).to eq("luckystar@email.com")
    end

    it "does not allow access to the merchant's password" do
      expect(merchant.password).to eq(nil)
    end

    #it "knows the merchant's products" do
    #  expect(merchant.products.size).to eq(2)
    #end
  end
end






