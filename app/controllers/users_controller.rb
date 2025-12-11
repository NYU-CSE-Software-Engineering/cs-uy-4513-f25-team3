class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:signup_success] = "Account created successfully"
      redirect_to itineraries_path
    else
      render :new
    end
  end

  def edit
    correct_id = session[:user_id].to_s
    if params[:id] != correct_id
      return redirect_to edit_user_path(correct_id)
    end
  end

  def update
    if params[:current_password] != @user.password
      flash.now[:alert] = "Current password is incorrect"
      return render :edit
    end

    # we will work with modifiable parameters
    update_params = user_params.dup

    new_password = update_params[:password]
    confirm      = update_params[:password_confirmation]

    # when BOTH password fields are empty we ignore password update entirely
    if new_password.blank? && confirm.blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)

    elsif new_password.blank? && confirm.present?
      flash.now[:alert] = "New password cannot be blank"
      return render :edit

    elsif new_password.present? && confirm.blank?
      flash.now[:alert] = "Password confirmation can't be blank"
      return render :edit

    elsif new_password != confirm
      flash.now[:alert] = "New password and confirmation do not match"
      return render :edit
    end

    if update_params[:username].present? &&
       update_params[:username] != @user.username &&
       User.exists?(username: update_params[:username])
      flash.now[:alert] = "Username already taken"
      return render :edit
    end

    if @user.update(update_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to itineraries_path
    else
      flash.now[:alert] = "There was an error in updating the profile"
      render :edit
    end
  end



  private

  def set_user
    if @user != User.find(session[:user_id])
      @user = User.find(session[:user_id])
    end
  end
  
  def user_params
    params.require(:user).permit(
      :username,
      :role,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      :age,
      :gender
    )
  end

end
