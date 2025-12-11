require 'rails_helper'

RSpec.describe "Itinerary Editing", type: :request do
  let!(:organizer) do
    User.create!(
      username: 'organizer_user',
      password: 'password123',
      password_confirmation: 'password123',
      role: 'organizer'
    )
  end

  let!(:itinerary) do
    ItineraryGroup.create!(
      title: 'NYC Tour',
      description: 'Exploring NYC',
      location: 'New York',
      start_date: Date.parse('2026-01-01'),
      end_date: Date.parse('2026-01-14'),
      is_private: false,
      cost: 2400,
      organizer_id: organizer.id
    )
  end

  before do
    post login_path, params: { user: { username: organizer.username, password: 'password123' } }
  end

  describe "GET /itineraries/:id/edit" do
    it "renders the edit template with all fields pre-populated" do
      get edit_itinerary_path(itinerary)
      
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
      expect(response.body).to include('NYC Tour')
      expect(response.body).to include('Exploring NYC')
      expect(response.body).to include('New York')
      expect(response.body).to include('2026-01-01')
      expect(response.body).to include('2026-01-14')
      expect(response.body).to include('2400')
    end

    it "shows Trip Type as Public when is_private is false" do
      get edit_itinerary_path(itinerary)
      
      expect(response.body).to include('Trip Type')
      expect(response.body).to include('Public')
    end

    it "shows Trip Type as Private when is_private is true" do
      itinerary.update!(is_private: true, password: 'secret123')
      get edit_itinerary_path(itinerary)
      
      expect(response.body).to include('Private')
    end
  end

  describe "PATCH /itineraries/:id" do
    context "with valid attributes" do
      it "updates all editable fields successfully" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            title: 'New York Adventure',
            description: 'A fun trip to NYC',
            location: 'Manhattan',
            start_date: '2026-02-01',
            end_date: '2026-02-14',
            is_private: true,
            password: 'newpassword',
            cost: 3000
          }
        }

        itinerary.reload
        expect(itinerary.title).to eq('New York Adventure')
        expect(itinerary.description).to eq('A fun trip to NYC')
        expect(itinerary.location).to eq('Manhattan')
        expect(itinerary.start_date).to eq(Date.parse('2026-02-01'))
        expect(itinerary.end_date).to eq(Date.parse('2026-02-14'))
        expect(itinerary.is_private).to be true
        expect(itinerary.cost).to eq(3000)
        expect(response).to redirect_to(itinerary_path(itinerary))
        expect(flash[:notice]).to eq('Itinerary was successfully updated.')
      end

      it "updates only the title" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            title: 'Updated Title Only'
          }
        }

        itinerary.reload
        expect(itinerary.title).to eq('Updated Title Only')
        expect(itinerary.description).to eq('Exploring NYC')
      end

      it "updates only the cost" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            cost: 5000
          }
        }

        itinerary.reload
        expect(itinerary.cost).to eq(5000)
      end
    end

    context "with invalid attributes" do
      it "does not update when title is blank" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            title: ''
          }
        }

        expect(response).to render_template(:edit)
        expect(response.body).to include("Title can&#39;t be blank")
        itinerary.reload
        expect(itinerary.title).to eq('NYC Tour')
      end

      it "does not update when end_date is before start_date" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            start_date: '2026-05-05',
            end_date: '2026-05-01'
          }
        }

        expect(response).to render_template(:edit)
        expect(response.body).to include('end_date must be after or the same as start_date')
        itinerary.reload
        expect(itinerary.start_date).to eq(Date.parse('2026-01-01'))
      end

      it "does not update when cost is negative" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            cost: -100
          }
        }

        expect(response).to render_template(:edit)
        expect(response.body).to include('Cost must be greater or equal to 0')
        itinerary.reload
        expect(itinerary.cost).to eq(2400)
      end

      it "does not update when location is blank" do
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            location: ''
          }
        }

        expect(response).to render_template(:edit)
        expect(response.body).to include("Location field can&#39;t be blank")


        itinerary.reload
        expect(itinerary.location).to eq('New York')
      end
    end

    context "authorization" do
      let!(:another_user) do
        User.create!(
          username: 'another_user',
          password: 'password123',
          password_confirmation: 'password123',
          role: 'user'
        )
      end

      it "prevents non-organizers from editing the itinerary" do
        post login_path, params: { user: { username: another_user.username, password: 'password123' } }
        
        patch itinerary_path(itinerary), params: {
          itinerary_group: {
            title: 'Hacked Title'
          }
        }

        expect(response).to redirect_to(itinerary_path(itinerary))
        expect(flash[:alert]).to eq('You must be the organizer to edit this itinerary.')
        itinerary.reload
        expect(itinerary.title).to eq('NYC Tour')
      end

      it "prevents non-organizers from accessing the edit page" do
        post login_path, params: { user: { username: another_user.username, password: 'password123' } }
        
        get edit_itinerary_path(itinerary)

        expect(response).to redirect_to(itinerary_path(itinerary))
        expect(flash[:alert]).to eq('You must be the organizer to edit this itinerary.')
      end

      it "allows the organizer to edit their own itinerary" do
        get edit_itinerary_path(itinerary)

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end
  end
end