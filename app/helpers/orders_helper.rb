module OrdersHelper
  def order_status_color(status)
    case status
    when 'pending'
      'bg-yellow-200 text-yellow-800'
    when 'confirmed'
      'bg-blue-200 text-blue-800'
    when 'in_progress'
      'bg-purple-200 text-purple-800'
    when 'completed'
      'bg-green-200 text-green-800'
    when 'cancelled'
      'bg-red-200 text-red-800'
    end
  end
end
