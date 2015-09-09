require 'rails_helper'

RSpec.describe Review, type: :model do

  describe "model validations" do
    it "requires content, rating, and product_id" do
      review = Review.new

      expect(review).to_not be_valid
      expect(review.errors.keys).to include(:content,:rating,:product_id)
    end

    it "belongs to a product" do
      expect(Review.reflect_on_association(:product).macro).to eq(:belongs_to)
    end

  end

end
