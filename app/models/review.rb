class Review < ActiveRecord::Base
  # Validations
  validates :content, presence: true
  validates :rating, presence: true, numericality: { only_integer: true }
  validates :product_id, presence: true

  # Associations
  belongs_to :product
end
