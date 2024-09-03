require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:menu) }
    it { should have_many(:order_items) }
    it { should have_many(:orders).through(:order_items) }
  end

  describe 'enums' do
    it { should define_enum_for(:availability).with_values(available: 0, out_of_stock: 1) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu_item)).to be_valid
    end
  end
end
