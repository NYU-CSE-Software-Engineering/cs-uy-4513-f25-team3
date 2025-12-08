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
    # @user is set in before_action
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully"
      redirect_to itineraries_path
    else
      flash[:notice] = "There was an error in updating the profile"
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :role, :password, :password_confirmation)
  end
end
