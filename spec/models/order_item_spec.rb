require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:menu_item) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:order_item)).to be_valid
    end
  end
end
