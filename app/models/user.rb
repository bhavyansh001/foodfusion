class User < ApplicationRecord
  before_create :ensure_api_token

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { visitor: 0, owner: 1 }

  has_many :restaurants, foreign_key: :owner_id
  has_many :orders, foreign_key: :visitor_id

  private

  def ensure_api_token
    self.api_token ||= generate_api_token
  end

  def generate_api_token
    loop do
      token = SecureRandom.hex(20)
      break token unless User.exists?(api_token: token)
    end
  end
end
