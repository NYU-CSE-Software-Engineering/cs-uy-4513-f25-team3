class ItineraryHotel < ApplicationRecord
  belongs_to :hotel
  belongs_to :itinerary_group

  validates :hotel_id, uniqueness: { scope: :itinerary_group_id }
end
