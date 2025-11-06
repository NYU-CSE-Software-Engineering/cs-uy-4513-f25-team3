class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  #this will track the current user logged in, using it for a stub now
  def current_user
    nil # later will get the user_id from the session
  end

=begin  
  when we have sessions and login: 
  if session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  else:
    nill
=end

  

  def require_login # checks if user is logged in, called before all protected pages
    redirect_to login_path unless current_user
  end

end
