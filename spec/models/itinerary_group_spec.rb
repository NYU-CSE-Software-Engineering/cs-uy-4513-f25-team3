require 'rails_helper'

RSpec.describe ItineraryGroup, type: :model do
  it 'is invalid without a group_name' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:title]).to include("can't be blank")
  end

  it 'has many itinerary_attendees' do
    assoc = ItineraryGroup.reflect_on_association(:itinerary_attendees)
    expect(assoc.macro).to eq(:has_many)
  end

  it 'has many users through itinerary_attendees' do
    assoc = ItineraryGroup.reflect_on_association(:users)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:through]).to eq(:itinerary_attendees)
  end

  it 'has many attendees through itinerary_attendees' do
    assoc = ItineraryGroup.reflect_on_association(:attendees)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:through]).to eq(:itinerary_attendees)
    expect(assoc.options[:source]).to eq(:user)
  end

  it 'belongs to organizer' do
    assoc = ItineraryGroup.reflect_on_association(:organizer)
    expect(assoc.macro).to eq(:belongs_to)
    expect(assoc.options[:class_name]).to eq('User')
  end

  it 'has many flights through itinerary_flights' do
    assoc = ItineraryGroup.reflect_on_association(:flights)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:through]).to eq(:itinerary_flights)
  end

  it 'has many hotels through itinerary_hotels' do
    assoc = ItineraryGroup.reflect_on_association(:hotels)
    expect(assoc.macro).to eq(:has_many)
    expect(assoc.options[:through]).to eq(:itinerary_hotels)
  end

  it 'has many messages' do
    assoc = ItineraryGroup.reflect_on_association(:messages)
    expect(assoc.macro).to eq(:has_many)
  end
end