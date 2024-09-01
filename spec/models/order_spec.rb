require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:visitor).class_name('User') }
    it { should belong_to(:restaurant) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:menu_items).through(:order_items) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, confirmed: 1, in_progress: 2, completed: 3, cancelled: 4) }
  end

  describe 'callbacks' do
    #
  end

  describe 'broadcasting' do
    it 'broadcasts to the correct stream' do
      #
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:order)).to be_valid
    end
  end

  describe 'private methods' do
    let(:order) { create(:order) }

    it 'broadcasts status update' do
      #
    end

    it 'enqueues status update email job' do
      expect { order.send(:send_status_update_email) }.to have_enqueued_job(OrderStatusUpdateMailerJob).with(order.id)
    end
  end
end
