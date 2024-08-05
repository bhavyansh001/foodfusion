class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { visitor: 0, owner: 1 }

  has_many :restaurants, foreign_key: :owner_id
  has_many :orders, foreign_key: :visitor_id
end
