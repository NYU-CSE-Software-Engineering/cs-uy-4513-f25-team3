class User < ApplicationRecord
  validates :role, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true

  has_many :itinerary_attendees, dependent: :destroy
  has_many :itinerary_groups, through: :itinerary_attendees
  has_many :organized_groups, class_name: 'ItineraryGroup', foreign_key: 'organizer_id', dependent: :destroy
end