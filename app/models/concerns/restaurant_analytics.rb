module RestaurantAnalytics
  extend ActiveSupport::Concern

  def total_revenue
    orders.where(status: 'completed').sum(:total_price)
  end

  def average_order_value
    orders.where(status: 'completed').average(:total_price)
  end

  def revenue_by_day
    orders.where(status: 'completed')
          .group('DATE(created_at)')
          .sum(:total_price)
  end

  def top_items
    menu_items.joins(order_items: :order)
              .where(orders: { status: 'completed' })
              .group('menu_items.id')
              .order('SUM(order_items.quantity) DESC')
              .limit(5)
  end

  def highest_revenue_items
    menu_items.joins(order_items: :order)
              .where(orders: { status: 'completed' })
              .group('menu_items.id')
              .order(Arel.sql('SUM(order_items.quantity * order_items.price) DESC'))
              .limit(5)
  end

  def total_customers
    orders.select(:visitor_id).distinct.count
  end

  def returning_customers
    orders.group(:visitor_id)
          .having('COUNT(*) > 1')
          .count
          .length
  end
end
