require "rails_helper"

RSpec.describe "Flight search and filtering", type: :request do
  let!(:user) { User.create!(username: "flight_user", password: "password", role: "user") }

  before do
    post login_path, params: { user: { username: user.username, password: user.password } }
  end

  let!(:ic067) do
    Flight.create!(
      flight_number:      "IC067",
      departure_location: "New York",
      arrival_location:   "Austin",
      departure_time:     Time.zone.parse("2025-12-04 09:00:00"),
      arrival_time:       Time.zone.parse("2025-12-04 13:00:00"),
      cost:               400
    )
  end

  let!(:dl202) do
    Flight.create!(
      flight_number:      "DL202",
      departure_location: "Boston",
      arrival_location:   "Miami",
      departure_time:     Time.zone.parse("2025-12-05 10:00:00"),
      arrival_time:       Time.zone.parse("2025-12-05 14:00:00"),
      cost:               425
    )
  end

  describe "GET /flights search and filter" do
    it "shows all flights when no filters are applied" do
      get flights_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("IC067", "DL202")
    end

    it "searches flights by departure location" do
      get flights_path, params: { departure_location: "New York", commit: "Search" }

      expect(response.body).to include("IC067")
      expect(response.body).not_to include("DL202")
    end

    it "searches flights by arrival location" do
      get flights_path, params: { arrival_location: "Miami", commit: "Search" }

      expect(response.body).to include("DL202")
      expect(response.body).not_to include("IC067")
    end

    it "filters flights by cost range" do
      get flights_path, params: { min_cost: 300, max_cost: 410, commit: "Search" }

      expect(response.body).to include("IC067")
      expect(response.body).not_to include("DL202")
    end

    it "shows 'No flights found' when nothing matches" do
      get flights_path, params: { departure_location: "Antarctica", commit: "Search" }

      expect(response.body).to include("No flights found")
      expect(response.body).not_to include("IC067", "DL202")
    end

    it "shows an error for invalid cost input" do
      get flights_path, params: { min_cost: "abc", max_cost: "", commit: "Search" }

      expect(response.body).to include("Please enter valid numbers for cost")
    end

    it "shows an error when end date is before start date" do
      get flights_path, params: {
        start_date: "2025-12-10",
        end_date:   "2025-12-01",
        commit:     "Search"
      }

      expect(response.body).to include("End date must be after start date")
    end
  end
end

