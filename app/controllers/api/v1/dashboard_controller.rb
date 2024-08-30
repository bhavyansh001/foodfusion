module Api
  module V1
    class DashboardController < BaseController
      def show
        if current_user.owner?
          render json: owner_dashboard_data
        else
          render json: visitor_dashboard_data
        end
      end

      private

      def owner_dashboard_data
        restaurants = current_user.restaurants
        {
          restaurants: restaurants.map do |restaurant|
            {
              id: restaurant.id,
              name: restaurant.name,
              active_orders: active_orders(restaurant),
              daily_orders: daily_orders(restaurant),
              analytics: restaurant_analytics(restaurant)
            }
          end
        }
      end

      def visitor_dashboard_data
        {
          active_orders: current_user.orders.where(
            status: ['pending', 'confirmed', 'in_progress']),
          order_history: current_user.orders.where(
            status: ['completed', 'cancelled']).order(created_at: :desc).limit(10)
        }
      end

      def active_orders(restaurant)
        restaurant.orders.where(status: %w[pending preparing])
      end

      def daily_orders(restaurant)
        restaurant.orders.where('created_at >= ?', 1.day.ago).count
      end

      def restaurant_analytics(restaurant)
        {
          total_revenue: restaurant.total_revenue,
          average_order_value: restaurant.average_order_value,
          revenue_by_day: restaurant.revenue_by_day,
          top_items: restaurant.top_items,
          highest_revenue_items: restaurant.highest_revenue_items,
          order_status_distribution: restaurant.orders.group(:status).count,
          total_customers: restaurant.total_customers,
          returning_customers: restaurant.returning_customers,
          peak_hours: restaurant.orders.group_by_hour_of_day(:created_at).count,
          menu_item_availability: restaurant.menu_items.group(:availability).count
        }
      end
    end
  end
end
