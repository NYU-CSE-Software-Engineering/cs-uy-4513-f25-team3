class SessionsController < ApplicationController
    def new # for now only works when fed parameters manually until we implement login
        session[:user_id] = params[:user_id]
    end

    def create
        session[:user_id] = params[:user_id]
        redirect_to itineraries_path
    end


    def destroy
        session[:user_id] = nil
        flash[:notice] = "You have been logged out"
        redirect_to login_path
    end
end