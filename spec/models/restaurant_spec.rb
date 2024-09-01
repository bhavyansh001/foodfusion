require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
    it { should have_one(:menu).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu) }
    it { should have_many(:orders).dependent(:destroy) }
  end

  describe 'broadcasting' do
    it 'broadcasts to the correct stream' do
      #
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:restaurant)).to be_valid
    end
  end

  describe 'RestaurantAnalytics' do
    let(:restaurant) { create(:restaurant) }
    let!(:completed_orders) { create_list(:order, 3, :with_items, restaurant: restaurant, status: :completed) }
    let!(:pending_order) { create(:order, :with_items, restaurant: restaurant, status: :pending) }

    describe '#total_revenue' do
      it 'calculates total revenue from completed orders' do
        expected_revenue = completed_orders.sum(&:total_price)
        expect(restaurant.total_revenue).to eq(expected_revenue)
      end
    end

    describe '#average_order_value' do
      it 'calculates average order value from completed orders' do
        expected_average = completed_orders.sum(&:total_price) / completed_orders.count
        expect(restaurant.average_order_value).to be_within(0.01).of(expected_average)
      end
    end

    describe '#revenue_by_day' do
      it 'groups revenue by day for completed orders' do
        result = restaurant.revenue_by_day
        expect(result.keys).to all(be_a(Date))
        expect(result.values).to all(be_a(Numeric))
      end
    end

    describe '#top_items' do
      it 'returns top 5 items by quantity' do
        #
      end
    end

    describe '#highest_revenue_items' do
      it 'returns top 5 items by revenue' do
        #
      end
    end

    describe '#total_customers' do
      it 'counts distinct customers' do
        expect(restaurant.total_customers).to eq(restaurant.orders.select(:visitor_id).distinct.count)
      end
    end

    describe '#returning_customers' do
      it 'counts customers with more than one order' do
        create(:order, restaurant: restaurant, visitor: completed_orders.first.visitor)
        expect(restaurant.returning_customers).to eq(1)
      end
    end
  end
end
