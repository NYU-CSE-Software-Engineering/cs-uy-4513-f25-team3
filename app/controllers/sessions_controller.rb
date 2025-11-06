class SessionsController < ApplicationController
    def new # for now only works when fed parameters manually until we implement login
        session[:user_id] = params[:user_id]
    end

    def destroy
        session[:user_id] = nil
        redirect_to login_path
    end
end