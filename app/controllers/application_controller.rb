class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
        @current_user ||= User.find_by(id: session[:user_id])
  end
  
  before_action :require_login


  def require_login # checks if user is logged in, called before all protected pages
    unless session[:user_id]
      flash[:alert] = "Please log in to continue"
      redirect_to login_path 
    end
  end

  def require_admin
    unless current_user&.role == "admin"
      flash[:alert] = "Access Denied"
      redirect_to itineraries_path
    end
  end

end
