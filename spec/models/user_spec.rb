require 'rails_helper'

RSpec.describe User, type: :model do

    it 'is valid with username, password, and role' do
        user = User.new(username: "freddy", password: "pass123", password_confirmation: "pass123", role: "user")
        expect(user).to be_valid
    end

    it 'is invalid without a Username' do
        user = User.new(password: "abc123", password_confirmation: "abc123", role: "user")
        expect(user).not_to be_valid
    end
    it 'is invalid if Username already exists' do
        User.create!(username: "janey", password: "abc123", password_confirmation: "abc123", role: "user")
        duplicate = User.new(username: "janey", password: "pass123", password_confirmation: "pass123", role: "user")
        expect(duplicate).not_to be_valid
    end
    it 'is invalid without a Password' do
        user = User.new(username: "john123", role: "user")
        expect(user).not_to be_valid
    end
    it 'is invalid without a role' do
        user = User.new(username: 'testuser', password: 'password123', password_confirmation: "password123")
        expect(user).not_to be_valid
    end
    it "returns true for admin? if role is admin" do
        user = User.create!(username: "testadmin", password: "adminpass", password_confirmation: "adminpass", role: "admin")  
        expect(user.admin?).to be true
    end
    it "returns false for admin? if role is not admin" do
        user = User.create!(username: "testadmin", password: "adminpass", password_confirmation: "adminpass", role: "organizer")   
        expect(user.admin?).to be false
    end

    it 'has many itinerary_attendees' do
      assoc = User.reflect_on_association(:itinerary_attendees)
      expect(assoc.macro).to eq(:has_many)
    end

    it 'has many itinerary_groups through itinerary_attendees' do
      assoc = User.reflect_on_association(:itinerary_groups)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:itinerary_attendees)
    end

    it 'has many organized_groups' do
      assoc = User.reflect_on_association(:organized_groups)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:class_name]).to eq('ItineraryGroup')
      expect(assoc.options[:foreign_key]).to eq('organizer_id')
    end

end


