require 'rails_helper'

RSpec.describe ItineraryAttendee, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to an itinerary group' do
      association = described_class.reflect_on_association(:itinerary_group)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with a user and itinerary_group' do
      user = User.create!(username: 'testuser', password: 'pass123', role: 'user')
      group = ItineraryGroup.create!(title: 'Test Trip', organizer_id: user.id)
      attendee = ItineraryAttendee.new(user: user, itinerary_group: group)
      expect(attendee).to be_valid
    end
  end
end
