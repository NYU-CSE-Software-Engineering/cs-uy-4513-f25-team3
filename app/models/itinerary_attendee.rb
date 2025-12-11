class ItineraryAttendee < ApplicationRecord
    belongs_to :user
    belongs_to :itinerary_group

    validates :user_id, uniqueness: { 
        scope: :itinerary_group_id,
        message: 'is already part of itinerary'
    }
end