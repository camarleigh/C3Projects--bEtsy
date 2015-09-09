class Product < ActiveRecord::Base
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates_numericality_of :price, :greater_than => 0
  validates :length, :width, :weight, presence: true

  # Associations
  belongs_to :merchant
  has_many :order_items
  has_many :reviews
  has_and_belongs_to_many :categories
end
