class SessionsController < ApplicationController
    def new
        #placeholder for login redirection from logout
    end

    def destroy
        session[:user_id] = nil
        redirect_to login_path
    end
end