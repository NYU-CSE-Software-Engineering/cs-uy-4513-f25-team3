class SessionsController < ApplicationController
    def new 
        @user = User.new
    end

    def create
        user = User.find_by(username: params[:user][:username])
        if user && user.password == params[:user][:password]
            session[:user_id] = user.id
            redirect_to itineraries_path
        else
            flash[:alert] = "Invalid username and/or password"
            @user = User.new(username: "", password: "")
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:notice] = "You have been logged out"
        redirect_to login_path
    end
end