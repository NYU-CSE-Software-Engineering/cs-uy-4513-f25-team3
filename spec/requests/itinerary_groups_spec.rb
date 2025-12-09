require 'rails_helper'

RSpec.describe "ItineraryGroups", type: :request do

    describe "GET /itineraries/new" do
        it "renders the new template" do
            get new_itinerary_path

            expect(response).to have_http_status(:success)
            expect(response).to render_template(:new)
        end
    end

    describe "POST /itineraries" do
        it "creates a new itinerary and redirects to home" do
            post itineraries_path, params: {
                itinerary_group: {
                    title: "Valid Trip",
                    location: "NYC",
                    start_date: "2026-01-01",
                    end_date: "2026-01-10"
                }
            }
            
            expect(response).to redirect_to(root_path)
            expect(flash[:notice]).to eq("Itinerary Created")
        end

        it "re-renders the new template" do
            post itineraries_path, params: {
                itinerary_group: { title: "" }
            }

            expect(response).to render_template(:new)
        end
    end

    describe "GET /itineraries/:id/edit" do
        it "renders the edit template (settings page)" do
            itinerary_group = ItineraryGroup.create!(
                title: "NYC Tour",
                location: "NYC",
                start_date: Date.today + 1,
                end_date: Date.today + 2
            )
            
            get edit_itinerary_path(itinerary_group)
            
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:edit)
        end
    end


    describe "PATCH /itineraries/:id" do
        it "redirects to the show page after successful update" do
            itinerary_group = ItineraryGroup.create!(
                title: "NYC Tour",
                location: "NYC",
                start_date: Date.today + 1,
                end_date: Date.today + 2
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(response).to redirect_to(itinerary_path(itinerary_group))
        end

        it "sets a success flash message after successful update" do
            itinerary_group = ItineraryGroup.create!(
                title: "NYC Tour",
                location: "NYC",
                start_date: Date.today + 1,
                end_date: Date.today + 2
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(flash[:notice]).to eq("Itinerary was successfully updated.")
        end
    end
end