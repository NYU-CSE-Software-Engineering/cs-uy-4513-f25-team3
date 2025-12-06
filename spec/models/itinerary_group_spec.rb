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
    expect(itinerary_group.errors[:location]).to include("can't be blank")
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
    expect(itinerary_group.errors[:end_date]).to include("must be same as or after start date")
  end
end