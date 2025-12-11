require 'rails_helper'

RSpec.describe ItineraryAttendee, type: :model do
  it 'belongs to a user' do
    assoc = ItineraryAttendee.reflect_on_association(:user)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it 'belongs to an itinerary group' do
    assoc = ItineraryAttendee.reflect_on_association(:itinerary_group)
    expect(assoc.macro).to eq(:belongs_to)
  end

  it 'is valid with a user and itinerary_group' do
    user = User.create!(
      username: 'testuser', 
      password: 'pass123', 
      password_confirmation: 'pass123',
      role: 'user'
    )
    group = ItineraryGroup.create!(
      title: 'Test Trip', 
      organizer_id: user.id,
      start_date: Date.today,
      end_date: Date.today + 7.days
    )
    attendee = ItineraryAttendee.new(user: user, itinerary_group: group)
    expect(attendee).to be_valid

  end
end
