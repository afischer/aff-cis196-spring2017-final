class User < ActiveRecord::Base
  has_many :parties, through: :party_users
end
