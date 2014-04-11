class SignupsController < ApplicationController
  skip_before_action :current_user_required

  def new
    @user = User.new
  end

  def create
    @user = User.signup(signup_params)
    if @user.valid?
      @account = @user.accounts.first
      login(@user)
      redirect_to @account
    else
      render :new
    end
  end

  private

  def signup_params
    params.require(:user).permit(:name, :email, :password)
  end
end
