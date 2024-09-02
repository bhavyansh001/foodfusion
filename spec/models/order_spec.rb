require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:visitor).class_name('User') }
    it { should belong_to(:restaurant) }
    it { should have_many(:order_items).dependent(:destroy) }
    it { should have_many(:menu_items).through(:order_items) }
  end

  describe 'enums' do
    it {
      should define_enum_for(:status).with_values(
        pending: 0,
        confirmed: 1,
        in_progress: 2,
        completed: 3,
        cancelled: 4
      )
    }
  end

  describe 'callbacks' do
    let(:order) { create(:order) }

    it 'calls broadcast_status_update after update commit' do
      allow(order).to receive(:broadcast_status_update)
      order.update(status: 'confirmed')
      expect(order).to have_received(:broadcast_status_update)
    end

    it 'calls send_status_update_email after status change' do
      allow(order).to receive(:send_status_update_email)
      order.update(status: 'confirmed')
      expect(order).to have_received(:send_status_update_email)
    end
  end

  describe 'broadcasting' do
    let(:order) { create(:order) }
    let(:stream_name) { order.restaurant.to_gid_param + ':orders' }

    it 'broadcasts status update to the correct target' do
      order.update(status: 'confirmed')
      expect do
        order.broadcast_replace_to(
          [order.restaurant, 'orders'],
          target: "order_#{order.id}_status",
          partial: 'orders/status',
          locals: { order: }
        )
      end.to have_broadcasted_to(stream_name)
        .from_channel('Turbo::StreamsChannel')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:order)).to be_valid
    end
  end

  describe 'private methods' do
    let(:order) { create(:order) }
    let(:stream_name) { order.restaurant.to_gid_param + ':orders' }

    describe '#send_status_update_email' do
      it 'enqueues status update email job' do
        expect { order.send(:send_status_update_email) }
          .to have_enqueued_job(OrderStatusUpdateMailerJob)
          .with(order.id)
      end
    end
  end
end
