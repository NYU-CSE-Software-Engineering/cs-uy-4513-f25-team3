class Message < ApplicationRecord
  belongs_to :user
  belongs_to :itinerary_group

  # Optional validations (not required)
  # validates :text, presence: true
end
