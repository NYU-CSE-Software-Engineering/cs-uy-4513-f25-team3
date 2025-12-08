class ItineraryFlight < ApplicationRecord
  belongs_to :flight
  belongs_to :itinerary_group

  validates :flight_id, uniqueness: { scope: :itinerary_group_id }
end
