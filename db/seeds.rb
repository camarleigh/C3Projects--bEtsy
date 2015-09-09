require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CSV.foreach("db/seed_data_products.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    Product.create(row.to_hash)
end

CSV.foreach("db/seed_data_merchants.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    Merchant.create(
      name: row[:name],
      email: row[:email],
      password: row[:password],
      password_confirmation: row[:password_confirmation]
      )
end

CSV.foreach("db/seed_data_reviews.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    Review.create(row.to_hash)
end

CSV.foreach("db/seed_data_categories.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
  Category.create(row.to_hash)
end

CSV.foreach("db/seed_data_order_items.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    OrderItem.create(row.to_hash)
end

CSV.foreach("db/seed_data_orders.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
    Order.create(row.to_hash)
end
