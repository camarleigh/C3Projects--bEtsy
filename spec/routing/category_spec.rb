require 'rails_helper'
require 'pry'

RSpec.describe "routes for Categores", type: :routing do

  it "routes to #index from /categories" do
    expect(get("/categories")).to route_to("categories#index")
  end

  it "routes to #new from get /categories/new" do
    expect(get("/categories/new")).to route_to("categories#new")
  end

  it "routes to #create from post /categories" do
    expect(post("/categories")).to route_to("categories#create")
  end

  it "get /categories/:id is routable" do
    expect(get("/categories/1")).to be_routable
  end
end
