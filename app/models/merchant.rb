class Merchant < ApplicationRecord
  has_many :products

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash["uid"]
    merchant.provider = auth_hash["provider"]
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    #user has not been saved, will be saved outside of this method
    return merchant
  end

  def total_revenue
    valid_orders = get_valid_orders

    total_revenue = 0.0
    valid_orders.each do |order|
      order.order_items.each do |item|
        total_revenue += item.quantity * item.product.price
      end
    end

    return total_revenue
  end

  def revenue_for(status)
    valid_orders = get_valid_orders

    total_revenue = 0.0
    specific_status_orders = valid_orders.select { |order| order.status == status }
    specific_status_orders.each do |order|
      order.order_items.each do |item|
        total_revenue += item.quantity * item.product.price
      end
    end

    return total_revenue
  end


  private 

  def get_valid_orders 
    merchant_products = self.products 
    merchant_orders = []
    merchant_products.each do |product|
      merchant_orders += product.orders
    end
    merchant_orders.uniq! 
    
    return merchant_orders.select { |order| order.status != "cancelled" }
  end
end
