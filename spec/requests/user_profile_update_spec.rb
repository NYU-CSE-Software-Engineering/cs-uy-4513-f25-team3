require 'rails_helper'

RSpec.describe "User profile update", type: :request do
  let!(:user) do
    FactoryBot.create(
      :user,
      username: "original_user",
      password: "currentpass",
      password_confirmation: "currentpass",
      role: "user"
    )
  end

  let!(:other_user) do
    FactoryBot.create(
      :user,
      username: "taken_name",
      password: "somepass",
      password_confirmation: "somepass",
      role: "user"
    )
  end

  before do
    # log in as the user whose profile we edit
    post login_path, params: {
      user: { username: user.username, password: "currentpass" }
    }
  end

  describe "PATCH /users/:id" do
    context "when new username is already taken" do
      it "re-renders edit with 'Username already taken' flash" do
        patch user_path(user), params: {
          user: {
            username: "taken_name",
            role: user.role,
            password: "",
            password_confirmation: ""
          },
          current_password: "currentpass"
        }

        expect(response).to render_template(:edit)
        text = CGI.unescapeHTML(response.body)
        expect(text).to include("Username already taken")

        user.reload
        expect(user.username).to eq("original_user")
      end
    end

    context "when update succeeds" do
      it "redirects" do
        patch user_path(user), params: {
          user: {
            username: "new_name",
            role: user.role,
            password: "",
            password_confirmation: ""
          },
          current_password: "currentpass"
        }

        expect(response).to redirect_to(itineraries_path)
        follow_redirect!
        text = CGI.unescapeHTML(response.body)
        user.reload
        expect(user.username).to eq("new_name")
      end
    end
  end
end
