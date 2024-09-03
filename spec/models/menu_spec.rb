require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_items).dependent(:destroy) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:menu)).to be_valid
    end
  end
end
