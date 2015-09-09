require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe "model validations" do
    it "requires a name, email, and password and password_confirmation all the time" do
      merchant = Merchant.new

      expect(merchant).to_not be_valid
      expect(merchant.errors.keys).to include(:name,:email,:password,:password_confirmation)
    end
  end

  describe "model validations" do
    it "has many products, order_items and orders (through order_items)" do
      expect(Merchant.reflect_on_association(:products).macro).to eq(:has_many)
      expect(Merchant.reflect_on_association(:orders).macro).to eq(:has_many)
      expect(Merchant.reflect_on_association(:order_items).macro).to eq(:has_many)
    end
  end
end
