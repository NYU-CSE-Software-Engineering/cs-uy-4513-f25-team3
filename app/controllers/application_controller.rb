class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern


  def require_login # checks if user is logged in, called before all protected pages
    redirect_to login_path unless session[:user_id]
  end

end
