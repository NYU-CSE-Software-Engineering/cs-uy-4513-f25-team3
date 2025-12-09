class AccountsController < ApplicationController
    before_action :require_admin, only: [:index, :update, :destroy]
    
    def require_admin
        unless current_user&.admin?
            flash[:alert] = "Access Denied"
            redirect_to itineraries_path
        end
    end

    def index 
        @accounts = User.where.not(id: current_user.id) # all accounts except current user
    end
    def destroy
        user = User.find_by(id: params[:id])
        unless current_user.admin?
            redirect_to itineraries_path, alert: "Access Denied" and return
        end

        if user
            user.destroy
            redirect_to accounts_path, notice: "Account deleted"
        else
            redirect_to accounts_path, alert: "Account does not exist"
        end
    end
    def update
        user = User.find_by(id: params[:id])
        unless current_user.admin?
            redirect_to itineraries_path, alert: "Access Denied" and return
        end
        new_role = params[:user][:role]
        if ["user", "organizer", "admin"].include?(new_role)
            user.update(role: new_role)
            redirect_to accounts_path, notice: "Account role updated successfully"
        else
            redirect_to accounts_path, alert: "Invalid role type"
        end

    end
end