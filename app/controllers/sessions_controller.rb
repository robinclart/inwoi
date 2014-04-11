class SessionsController < ApplicationController
  skip_before_action :current_user_required, except: [:destroy]

  def new
  end

  def create
    @user = User.find_by email: params[:email]
    if @user && @user.authenticate(params[:password])
      login @user
      @account = @user.accounts.first
      redirect_to @account
    else
      redirect_to :login
    end
  end

  def destroy
    logout
    redirect_to :login
  end
end
