require 'rails_helper'

RSpec.describe ItineraryAttendee, type: :model do
    let(:user) do 
        User.create!(
            username: 'chris', 
            password: 'password', 
            password_confirmation: 'password', 
            role: 'user'
        )
    end

    let(:group) do
        ItineraryGroup.create!(
            title: 'Public Europe Trip',
            location: 'Europe',
            start_date: Date.today + 1,
            end_date: Date.today + 2,
            is_private: false,
            cost: 2000
        )
    end

    it 'is valid with a user and itinerary group' do
        attendee = ItineraryAttendee.new(user: user, itinerary_group: group)
        expect(attendee).to be_valid
    end

    it 'is invalid without a user' do
        attendee = ItineraryAttendee.new(itinerary_group: group)
        expect(attendee).not_to be_valid
        expect(attendee.errors[:user]).to include('must exist')
    end

    it 'is invalid without an itinerary group' do
        attendee = ItineraryAttendee.new(user: user)
        expect(attendee).not_to be_valid
        expect(attendee.errors[:itinerary_group]).to include('must exist')
    end

    it 'does not allow a user to join an itinerary they are already in' do
        ItineraryAttendee.create!(user: user, itinerary_group: group)
        attendee = ItineraryAttendee.new(user: user, itinerary_group: group)

        expect(attendee).not_to be_valid
        expect(attendee.errors[:user_id]).to include('is already part of itinerary')
    end
end






    