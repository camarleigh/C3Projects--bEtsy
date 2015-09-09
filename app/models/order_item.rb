class OrderItem < ActiveRecord::Base
  # Validations
  validates :product_id, presence: true
  validates :order_id, presence: true
  validates :revenue, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Associations
  belongs_to :order
  belongs_to :product
  belongs_to :merchant

end
