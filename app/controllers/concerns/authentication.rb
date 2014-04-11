module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
    before_action :current_user_required
  end

  private

  def set_current_user
    if user_id = cookies.signed.permanent[:user_id]
      @current_user = User.where(id: user_id).first
    end
  end

  def current_user_required
    redirect_to login_path unless @current_user
  end

  def login(user)
    cookies.signed.permanent[:user_id] = user.id
  end

  def logout
    cookies.signed.permanent[:user_id] = nil
  end
end