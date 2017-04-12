class Party < ActiveRecord::Base
  has_many :songs
  has_many :users, through: :party_users
end
