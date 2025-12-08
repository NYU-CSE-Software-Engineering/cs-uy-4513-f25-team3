require "rails_helper"

RSpec.describe Hotel, type: :model do
  it "is valid with valid attributes" do
    hotel = build(:hotel)
    expect(hotel).to be_valid
  end

  it "is invalid without a name" do
    hotel = build(:hotel, name: nil)
    expect(hotel).not_to be_valid
    expect(hotel.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a location" do
    hotel = build(:hotel, location: nil)
    expect(hotel).not_to be_valid
    expect(hotel.errors[:location]).to include("can't be blank")
  end

  it "allows a float rating within range" do
    hotel = build(:hotel, rating: 3.5)
    expect(hotel).to be_valid
  end

  it "is invalid with a rating outside 1..5" do
    hotel = build(:hotel, rating: 6.0)
    expect(hotel).not_to be_valid
    expect(hotel.errors[:rating]).to include("must be less than or equal to 5.0")
  end

  it "is invalid with a rating below 1" do
    hotel = build(:hotel, rating: 0.5)
    expect(hotel).not_to be_valid
    expect(hotel.errors[:rating]).to include("must be greater than or equal to 1.0")
  end

  it "is invalid with a negative cost" do
    hotel = build(:hotel, cost: -50)
    expect(hotel).not_to be_valid
    expect(hotel.errors[:cost]).to include("must be greater than or equal to 0")
  end
end
