require 'rails_helper'

RSpec.describe "ItineraryGroups", type: :request do
    let!(:user) do
        User.create!(
          username: "group_user",
          password: "password123",
          password_confirmation: "password123",
          role: "user"
        )
    end

    before do
        post login_path, params: { user: { username: user.username, password: "password123" } }
    end

    describe "GET /itineraries/:id/edit" do
        it "renders the edit template (settings page)" do
            itinerary_group = ItineraryGroup.create!(
                title: "NYC Tour",
                start_date: Date.today,
                end_date: Date.today + 1
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
                start_date: Date.today,
                end_date: Date.today + 1
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(response).to redirect_to(itinerary_path(itinerary_group))
        end

        it "sets a success flash message after successful update" do
            itinerary_group = ItineraryGroup.create!(
                
                title: "NYC Tour",
                start_date: Date.today,
                end_date: Date.today + 1
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(flash[:notice]).to eq("Itinerary was successfully updated.")
        end
    end
end

