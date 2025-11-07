require 'rails_helper'

RSpec.describe "ItineraryGroups", type: :request do
    describe "GET /itineraries/:id/edit" do
        it "renders the edit template (settings page)" do
            itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
            
            get edit_itinerary_path(itinerary_group)
            
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:edit)
        end
    end


    describe "PATCH /itineraries/:id" do
        it "redirects to the show page after successful update" do
            itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(response).to redirect_to(itinerary_path(itinerary_group))
        end

        it "sets a success flash message after successful update" do
            itinerary_group = ItineraryGroup.create!(title: "NYC Tour")
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(flash[:notice]).to eq("Itinerary was successfully updated.")
        end
    end
end