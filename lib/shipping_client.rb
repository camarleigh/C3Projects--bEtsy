require 'httparty'
require 'timeout'

class ShippingClient
  # SHIPPING_RATES_URI = "https://shipping-info.herokuapp.com/shipping"
  # SHIPPING_INFO_URI = "https://shipping-info.herokuapp.com/shipping/shipping_order"

  SHIPPING_RATES_URI = Rails.env.production? ? "https://shipping-info.herokuapp.com/shipping" : "http://localhost:3000/shipping"
  SHIPPING_INFO_URI = Rails.env.production? ? "https://shipping-info.herokuapp.com/shipping/shipping_order" : "http://localhost:3000/shipping/shipping_order"

  def self.find_shipping_rates(params, products)
    shipment = set_shipment(params, products)
    HTTParty.get(SHIPPING_RATES_URI, :query => shipment)
  end

  def self.send_shipping_info(id, method, cost)
    shipping_data = set_shipping_data(id, method, cost)
    HTTParty.post(SHIPPING_INFO_URI, { :body => shipping_data, :headers => { "Content-Type" => "application/json" } })
  end

  private

  def self.set_shipment(params, products)
    {
      :origin => {
        :country => "US",
        :state => "CA",
        :city => "Beverly Hills",
        :zip => "90210"
      },
      :destination => {
        :country => params[:country],
        :state => params[:state],
        :city => params[:city],
        :zip => params[:zip]
      },
      :products => products,
      :order_id => params[:order_id]
    }
  end

  def self.set_shipping_data(id, method, cost)
    {
      :order_id => id,
      :shipping_method => method,
      :shipping_cost => cost
    }.to_json
  end
end
