class Party < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  has_one :current_song, class_name: 'Song'
  has_many :party_users
  has_many :users, through: :party_users
end
