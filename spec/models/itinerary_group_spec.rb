require 'rails_helper'

RSpec.describe ItineraryGroup, type: :model do
  it 'is invalid without a title' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:title]).to include("can't be blank")
  end

  it 'is invalid without a location' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors.full_messages).to include("Location field can't be blank")

  end

  it 'is invalid without a start_date' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:start_date]).to include("can't be blank")
  end

  it 'is invalid without a end_date' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:end_date]).to include("can't be blank")
  end

  it 'is invalid if end_date is before start_date' do
    itinerary_group = ItineraryGroup.new(
      title: "Japan Adventure",
      location: "Japan",
      start_date: '2026-01-12',
      end_date: '2026-01-11'
    )
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:base]).to include("end_date must be after or the same as start_date")
  end

  it 'is invalid if start date or end date are in the past' do
    past_start = ItineraryGroup.new(
      title: "Japan Adventure",
      location: "Japan",
      start_date: '2025-11-12',
      end_date: '2026-01-07'
    )
    expect(past_start).not_to be_valid
    expect(past_start.errors[:base]).to include("start_date and end_date must be in the future")

    past_end = ItineraryGroup.new(
      title: "Japan Adventure",
      location: "Japan",
      start_date: '2026-01-07',
      end_date: '2025-11-12'
    )
    expect(past_end).not_to be_valid
    expect(past_end.errors[:base]).to include("start_date and end_date must be in the future")
  end

  it 'is invalid without a password given it is private' do
    itinerary_group = ItineraryGroup.new(
      title: 'Korea Trip',
      location: 'Korea',
      start_date: '2026-05-11',
      end_date: '2026-05-25',
      is_private: true
    )
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:password]).to include('required for private trips')
  end

  it "is invalid when cost is negative" do
    itinerary = ItineraryGroup.new(cost: -100)
    expect(itinerary).not_to be_valid
    expect(itinerary.errors[:cost]).to include("must be greater or equal to 0")
  end

  it "is invalid when cost is not a number" do
    itinerary = ItineraryGroup.new(cost: "one hundred")
    expect(itinerary).not_to be_valid
    expect(itinerary.errors[:cost]).to include("is not a number")
  end

  # it "is invalid when cost is not an integer" do
  #   itinerary = ItineraryGroup.new(cost: 2537.56)
  #   expect(itinerary).not_to be_valid
  #   expect(itinerary.errors[:cost]).to include("must be an integer")
  # end
  
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