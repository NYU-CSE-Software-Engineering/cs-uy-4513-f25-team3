require "rails_helper"

RSpec.describe Flight, type: :model do
  it "is valid with valid attributes" do
    flight = build(:flight)
    expect(flight).to be_valid
  end

  it "is invalid without a flight_number" do
    flight = build(:flight, flight_number: nil)
    expect(flight).not_to be_valid
    expect(flight.errors[:flight_number]).to include("can't be blank")
  end

  it "is invalid without a departure_location" do
    flight = build(:flight, departure_location: nil)
    expect(flight).not_to be_valid
    expect(flight.errors[:departure_location]).to include("can't be blank")
  end

  it "is invalid without an arrival_location" do
    flight = build(:flight, arrival_location: nil)
    expect(flight).not_to be_valid
    expect(flight.errors[:arrival_location]).to include("can't be blank")
  end

  it "is invalid without a departure_time" do
    flight = build(:flight, departure_time: nil)
    expect(flight).not_to be_valid
    expect(flight.errors[:departure_time]).to include("can't be blank")
  end

  it "is invalid without an arrival_time" do
    flight = build(:flight, arrival_time: nil)
    expect(flight).not_to be_valid
    expect(flight.errors[:arrival_time]).to include("can't be blank")
  end

  it "is invalid with a negative cost" do
    flight = build(:flight, cost: -10)
    expect(flight).not_to be_valid
    expect(flight.errors[:cost]).to include("must be greater than or equal to 0")
  end
end

