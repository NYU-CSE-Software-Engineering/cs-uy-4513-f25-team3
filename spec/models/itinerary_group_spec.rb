require 'rails_helper'

RSpec.describe ItineraryGroup, type: :model do
  it 'is invalid without a group_name' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:title]).to include("can't be blank")
  end

  describe 'associations' do
    it 'has many itinerary_attendees' do
      association = described_class.reflect_on_association(:itinerary_attendees)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many attendees through itinerary_attendees' do
      association = described_class.reflect_on_association(:attendees)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:itinerary_attendees)
      expect(association.options[:source]).to eq(:user)
    end

    it 'belongs to organizer' do
      association = described_class.reflect_on_association(:organizer)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
    end
  end
end