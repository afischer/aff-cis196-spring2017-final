class User < ActiveRecord::Base
  validates :nickname, presence: true, uniqueness: true, length: { minimum: 2 }
  has_many :parties, through: :party_users
end
