class SessionsController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    def new 
        @user = User.new
    end

    def create
        user = User.find_by(username: params[:user][:username])
        if user&.authenticate(params[:user][:password])
            reset_session
            session[:user_id] = user.id
            redirect_to itineraries_path
        else
            flash[:alert] = "Invalid username and/or password"
            @user = User.new(username: "")
            render :new, status: :unprocessable_entity
        end
    end



    def destroy
        session[:user_id] = nil
        flash[:notice] = "You have been logged out"
        redirect_to login_path
    end
end