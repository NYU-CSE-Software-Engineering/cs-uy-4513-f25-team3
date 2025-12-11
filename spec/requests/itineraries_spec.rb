require "rails_helper"

RSpec.describe "Itinerary search and filtering", type: :request do
  let!(:user) do
    User.create!(
      username: "search_user",
      password: "password",
      password_confirmation: "password",
      role: "user"
    )
  end

  before do
    post login_path, params: { user: { username: user.username, password: user.password } }
  end

  let!(:hawaii_public) do
    ItineraryGroup.create!(
      title:       "Hawaii Trip",
      description: "Fun week in Hawaii",
      location:    "Honolulu",
      start_date:  1.day.from_now.to_date,
      end_date:    2.days.from_now.to_date,
      is_private:  false,
      cost:        1200
    )
  end

  let!(:hawaii_private) do
    ItineraryGroup.create!(
      title:       "Hawaii Private",
      description: "Private luxury getaway",
      location:    "Honolulu",
      start_date:  3.days.from_now.to_date,
      end_date:    4.days.from_now.to_date,
      is_private:  true,
      cost:        3000,
      password:    "ihatebugs"
    )
  end

  let!(:ski_escape) do
    ItineraryGroup.create!(
      title:       "Ski Escape",
      description: "Skiing adventure in Aspen",
      location:    "Aspen",
      start_date:  5.days.from_now.to_date,
      end_date:    6.days.from_now.to_date,
      is_private:  false,
      cost:        800
    )
  end

  let!(:beach_relax) do
    ItineraryGroup.create!(
      title:       "Beach Relax",
      description: "Relaxing on Miami beaches",
      location:    "Miami",
      start_date:  7.days.from_now.to_date,
      end_date:    8.days.from_now.to_date,
      is_private:  false,
      cost:        1500
    )
  end

  describe "GET /itineraries search and filter" do
    it "searches by keyword in title/description" do
      get itineraries_path, params: { search: "Hawaii", commit: "Search" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hawaii Trip", "Hawaii Private")
      expect(response.body).not_to include("Ski Escape", "Beach Relax")
    end

    it "filters by date range" do
      # Range that should only match Beach Relax (7–8 days from now)
      get itineraries_path, params: {
        start_date: 7.days.from_now.to_date.to_s,
        end_date:   8.days.from_now.to_date.to_s,
        commit:     "Search"
      }

      expect(response.body).to include("Beach Relax")
      expect(response.body).not_to include("Hawaii Trip", "Hawaii Private", "Ski Escape")
    end

    it "filters by location" do
      get itineraries_path, params: { location: "Aspen", commit: "Search" }

      expect(response.body).to include("Ski Escape")
      expect(response.body).not_to include("Hawaii Trip", "Hawaii Private", "Beach Relax")
    end

    it "filters by trip type (public/private)" do
      get itineraries_path, params: { trip_type: "Private", commit: "Search" }

      expect(response.body).to include("Hawaii Private")
      expect(response.body).not_to include("Hawaii Trip", "Ski Escape", "Beach Relax")
    end

    it "filters by cost range" do
      get itineraries_path, params: {
        min_cost: 700,
        max_cost: 1500,
        commit:   "Search"
      }

      expect(response.body).to include("Hawaii Trip", "Ski Escape", "Beach Relax")
      expect(response.body).not_to include("Hawaii Private")
    end

    it "combines multiple filters" do
      get itineraries_path, params: {
        search:     "Hawaii",
        trip_type:  "Public",
        start_date: 1.day.from_now.to_date.to_s,
        end_date:   2.days.from_now.to_date.to_s,
        commit:     "Search"
      }

      expect(response.body).to include("Hawaii Trip")
      expect(response.body).not_to include("Hawaii Private")
    end

    it "shows 'No itineraries found' when nothing matches" do
      get itineraries_path, params: { search: "Antarctica", commit: "Search" }

      expect(response.body).to include("No itineraries found")
    end

    it "shows an error for invalid cost" do
      get itineraries_path, params: { min_cost: "abc", commit: "Search" }

      expect(response.body).to include("Please enter valid numbers for cost")
    end

    it "shows an error when end date is before start date" do
      # Deliberately invalid: end date is BEFORE start date
      get itineraries_path, params: {
        start_date: 10.days.from_now.to_date.to_s,
        end_date:   5.days.from_now.to_date.to_s,
        commit:     "Search"
      }

      expect(response.body).to include("End date must be after start date")
    end

    it "does not apply filters until search is triggered" do
      get itineraries_path # no commit/search params

      expect(response.body).to include(
        "Hawaii Trip",
        "Hawaii Private",
        "Ski Escape",
        "Beach Relax"
      )
    end

    it "clears all filters when clear param is present" do
      # First, apply a filter
      get itineraries_path, params: { search: "Hawaii", commit: "Search" }
      expect(response.body).to include("Hawaii Trip", "Hawaii Private")
      expect(response.body).not_to include("Ski Escape", "Beach Relax")

      # Then clear
      get itineraries_path, params: { clear: "true" }

      expect(response.body).to include(
        "Hawaii Trip",
        "Hawaii Private",
        "Ski Escape",
        "Beach Relax"
      )
    end
  end
end
