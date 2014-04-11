class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def show
    @invoices = @account.all_invoices
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to @account
    else
      render :edit
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :info, :terms_and_policies)
  end

  def set_account
    @account = @current_user.accounts.find(params[:id])
  end
end
