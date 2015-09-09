require 'rails_helper'
RSpec.describe CategoriesController, type: :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

    describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do


      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

    describe "POST #create" do
    it "responds successfully with an HTTP 200 status code" do


      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

    describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do


      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end
end