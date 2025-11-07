require 'rails_helper'

RSpec.describe "ItineraryGroups", type: :request do
  describe "GET /itinerary_groups/:id/edit" do
    it "renders the edit template (settings page)" do
      itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
      
      get edit_itinerary_group_path(itinerary_group)
      
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end
end