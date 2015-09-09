require 'rails_helper'

RSpec.describe Product, type: :model do 

  describe "model validations" do
    # it "requires a name, description, and artist all the time" do
    #   album = Album.new

    #   expect(album).to_not be_valid
    #   expect(album.errors.keys).to include(:name,:description,:artist)
    # end
    
    it "belongs to a merchant, has many order_items and reviews, and has and belongs to many categories" do
      expect(Product.reflect_on_association(:merchant).macro).to eq(:belongs_to)
      expect(Product.reflect_on_association(:order_items).macro).to eq(:has_many)
      expect(Product.reflect_on_association(:reviews).macro).to eq(:has_many)
      expect(Product.reflect_on_association(:categories).macro).to eq(:has_and_belongs_to_many)
    end

  end

  # describe "best scope" do
  #   it "ranks all the albums by vote in descending order" do
  #     album1= Album.create(name:'a', artist:'b', description: 'c', vote:30)
  #     album2= Album.create(name:'a', artist:'b', description: 'c', vote:3)
  #     album3= Album.create(name:'a', artist:'b', description: 'c', vote:20)

  #     right_rank = [album1, album3, album2]

  #     expect(Album.best(3)).to eq right_rank
  #   end
  # end
end
