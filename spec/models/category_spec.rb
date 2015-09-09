require 'rails_helper'

RSpec.describe Category, type: :model do 

  describe "model validations" do
#     it "requires a name" do
#       category = Category.new

#       expect(category).to_not be_valid
#       expect(category.errors.keys).to include(:name,:description,:artist)
#     end

    it "has and belongs to many products" do
      expect(Category.reflect_on_association(:products).macro).to eq(:has_and_belongs_to_many)
    end

  end

end
