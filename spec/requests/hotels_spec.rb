require "rails_helper"

RSpec.describe "Hotel search and filtering", type: :request do
  let!(:user) { User.create!(username: "hotel_user", password: "password", role: "user") }

  before do
    post login_path, params: { user: { username: user.username, password: user.password } }
  end

  let!(:hilton) do
    Hotel.create!(
      name:           "Hilton Times",
      location:       "New York",
      rating:         3,
      arrival_time:   Time.zone.parse("2025-12-04 09:00:00"),
      departure_time: Time.zone.parse("2025-12-12 13:00:00"),
      cost:           300
    )
  end

  let!(:miami_resort) do
    Hotel.create!(
      name:           "Miami Resort",
      location:       "Miami",
      rating:         4,
      arrival_time:   Time.zone.parse("2025-12-05 10:00:00"),
      departure_time: Time.zone.parse("2025-12-09 14:00:00"),
      cost:           325
    )
  end

  describe "GET /hotels search and filter" do
    it "shows all hotels when no filters are applied" do
      get hotels_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hilton Times", "Miami Resort")
    end

    it "searches hotels by location" do
      get hotels_path, params: { search_location: "New York", commit: "Search" }

      expect(response.body).to include("Hilton Times")
      expect(response.body).not_to include("Miami Resort")
    end

    it "filters hotels by cost range" do
      get hotels_path, params: { min_cost: 200, max_cost: 320, commit: "Search" }

      expect(response.body).to include("Hilton Times")
      expect(response.body).not_to include("Miami Resort")
    end

    it "filters hotels by minimum rating" do
      get hotels_path, params: { min_rating: 4, commit: "Search" }

      expect(response.body).to include("Miami Resort")
      expect(response.body).not_to include("Hilton Times")
    end

    it "shows 'No hotels found' when nothing matches" do
      get hotels_path, params: { search_location: "Mars", commit: "Search" }

      expect(response.body).to include("No hotels found")
      expect(response.body).not_to include("Hilton Times", "Miami Resort")
    end

    it "shows an error for invalid cost input" do
      get hotels_path, params: { min_cost: "abc", max_cost: "", commit: "Search" }

      expect(response.body).to include("Please enter valid numbers for cost")
    end

    it "shows an error when end date is before start date" do
      get hotels_path, params: {
        start_date: "2025-12-08",
        end_date:   "2025-12-01",
        commit:     "Search"
      }

      expect(response.body).to include("End date must be after start date")
    end
  end
end

