class ItineraryGroup < ApplicationRecord
  validates :title, presence: true

  has_many :itinerary_attendees, dependent: :destroy
  has_many :attendees, through: :itinerary_attendees, source: :user
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id', optional: true

  def trip_type
    is_private? ? "Private" : "Public"
  end

  def trip_type=(value)
    self.is_private = value.to_s.casecmp("Private").zero?
  end
end