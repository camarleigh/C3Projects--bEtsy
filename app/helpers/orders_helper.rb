module OrdersHelper
  def shipping_cost(cost)
    return "$#{cost/100.00}"
  end

  def delivery_date(date)
    return date.to_datetime.strftime("%b %d, %Y")
  end
end
