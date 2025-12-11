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

    let!(:organizer) do
        User.create!(
            username: 'alice', 
            password: 'pass123', 
            password_confirmation: 'pass123',
            role: 'organizer'
        )
    end

    let!(:public_group) do
        ItineraryGroup.create!(
            title: "Public NYC Trip",
            description: "For Xmas!",
            location: "NYC",
            start_date: Date.today + 1,
            end_date: Date.today + 2,
            is_private: false,
        )
    end

    let!(:private_group) do
        ItineraryGroup.create!(
            title: "Private Europe Trip",
            description: "With the Boys!",
            location: "Spain",
            start_date: Date.today + 1,
            end_date: Date.today + 2,
            is_private: true,
            password: "spain123"
        )
    end

    before do
        post login_path, params: { user: { username: user.username, password: "password123" } }
    end

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
            recent = ItineraryGroup.last
            expect(response).to redirect_to(itinerary_path(recent))
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
                end_date: Date.today + 2,
                organizer_id: user.id
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
                end_date: Date.today + 2,
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
                end_date: Date.today + 2,
                organizer_id: user.id
            )
            
            patch itinerary_path(itinerary_group), params: {
                itinerary_group: { title: "NYC Tour Updated" }
            }
            
            expect(flash[:notice]).to eq("Itinerary was successfully updated.")
        end
    end

    describe "GET /itineraries/:id/join" do
        it 'renders join page for private itinerary groups' do
            get join_itinerary_path(private_group)

            expect(response).to have_http_status(:success)
            expect(response).to render_template(:join)
        end

        it 'renders the show page for public itinerary groups' do
            get join_itinerary_path(public_group)

            expect(response).to redirect_to(itinerary_path(public_group))
        end
    end

    describe "POST /itineraries/:id/join" do
        context 'when itinerary is public' do
            it 'adds user to list of attendees then redirects to show page' do
                post join_itinerary_path(public_group)

                expect(response).to redirect_to(itinerary_path(public_group))
                expect(flash[:notice]).to eq('You have joined the trip successfully.')
                expect(public_group.reload.users).to include(user)
            end
        end

        context 'when itinerary is private and password is correct' do
            it 'adds user to list of attendees then redirects to show page' do
                post join_itinerary_path(private_group), params: {password: 'spain123'}

                expect(response).to redirect_to(itinerary_path(private_group))
                expect(flash[:notice]).to eq('You have joined the trip successfully.')
                expect(private_group.reload.users).to include(user)
            end
        end

        context 'when itinerary is private and password is incorrect' do
            it 'does not add user to list of attendees and re-renders join template with error' do
                post join_itinerary_path(private_group), params: {password: 'wrong_password_omegalol'}

                expect(response).to render_template(:join)
                expect(flash[:alert]).to eq("Incorrect trip password.")
                expect(private_group.reload.users).not_to include(user)
            end
        end

        context 'when the user is already in the itinerary group' do
            it 'does not allow the attendee to join again' do
                post join_itinerary_path(public_group)
                expect(public_group.reload.users).to include(user)

                post join_itinerary_path(public_group)
                expect(public_group.reload.itinerary_attendees.count).to eq(1)
            end
        end
    end

    describe "GET /itineraries/:id" do
        let!(:itinerary_group) do
            ItineraryGroup.create!(
                title: "Europe Trip", 
                organizer_id: organizer.id,
                start_date: Date.today,
                end_date: Date.today + 7.days,
                location: "Europe"
            )
        end

        it "returns http success" do
            get itinerary_path(itinerary_group)
            expect(response).to have_http_status(:success)
        end

        it "assigns @itinerary_group" do
            get itinerary_path(itinerary_group)
            expect(assigns(:itinerary_group)).to eq(itinerary_group)
        end

        it "assigns @organizer" do
            get itinerary_path(itinerary_group)
            expect(assigns(:organizer)).to eq(organizer)
        end

        it "assigns @attendees" do
            member1 = User.create!(
                username: 'bob', 
                password: 'pass123',
                password_confirmation: 'pass123',
                role: 'user'
            )
            member2 = User.create!(
                username: 'carol', 
                password: 'pass123',
                password_confirmation: 'pass123',
                role: 'user'
            )
            ItineraryAttendee.create!(user: member1, itinerary_group: itinerary_group)
            ItineraryAttendee.create!(user: member2, itinerary_group: itinerary_group)
            
            get itinerary_path(itinerary_group)
            
            expect(assigns(:attendees)).to include(member1, member2)
        end
    end
end
