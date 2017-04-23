class User < ActiveRecord::Base
  validates :nickname, presence: true, uniqueness: true, length: { minimum: 2 }
  has_many :party_users
  has_many :parties, through: :party_users

  def dj?(party)
    party.dj_id = id
  end

  def self.temp_user_name
    "User #{SecureRandom.uuid[0, 5]}"
  end
end
