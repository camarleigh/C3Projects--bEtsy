class Merchant < ActiveRecord::Base
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: {with: /@/}
  validates :password, presence: true
  validates :password_confirmation, presence: true

  # Associations
  has_secure_password

  has_many :products
  has_many :orders, :through => :order_items
  has_many :order_items

  # Scopes

  #Merchant.find(1).shipped(true/false) returns all shipped order items
  def shipped?(boolean)
    order_items.where(shipped: boolean)
  end
end
