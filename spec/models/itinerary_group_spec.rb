require 'rails_helper'

RSpec.describe ItineraryGroup, type: :model do
  it 'is invalid without a group_name' do
    itinerary_group = ItineraryGroup.new
    expect(itinerary_group).not_to be_valid
    expect(itinerary_group.errors[:title]).to include("can't be blank")
  end
end