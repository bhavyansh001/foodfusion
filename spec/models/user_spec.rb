require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:restaurants).with_foreign_key(:owner_id) }
    it { should have_many(:orders).with_foreign_key(:visitor_id) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(visitor: 0, owner: 1) }
  end

  describe 'callbacks' do
    it 'ensures an API token is generated before creation' do
      user = build(:user)
      expect(user.api_token).to be_nil
      user.save
      expect(user.api_token).not_to be_nil
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe '#ensure_api_token' do
    it 'generates an API token before creation' do
      user = build(:user)
      expect(user.api_token).to be_nil
      user.save
      expect(user.api_token).not_to be_nil
    end

    it 'does not change the API token if one exists' do
      user = create(:user)
      original_token = user.api_token
      user.save
      expect(user.api_token).to eq(original_token)
    end
  end

  describe '#generate_api_token' do
    it 'generates a unique token' do
      user = create(:user)
      allow(SecureRandom).to receive(:hex).and_return('existing_token', 'new_token')
      allow(User).to receive(:exists?).with(api_token: 'existing_token').and_return(true)
      allow(User).to receive(:exists?).with(api_token: 'new_token').and_return(false)

      expect(user.send(:generate_api_token)).to eq('new_token')
    end
  end
end
