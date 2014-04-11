class InvoicesController < ApplicationController
  before_action :set_account
  before_action :set_invoice, only: [:edit, :update]

  def index
  end

  def new
    @invoice = @account.new_invoice({
      uid: @account.next_invoice_uid,
      account_name: @account.name,
      account_info: @account.info,
      account_terms_and_policies: @account.terms_and_policies
    })
  end

  def edit
  end

  def create
    @invoice = @account.new_invoice(invoice_params)
    if @invoice.save
      redirect_to [:edit, @account, @invoice]
    else
      render :new
    end
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to [@account, :invoices]
    else
      render :edit
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(
      :uid,
      :date,
      :account_name,
      :account_info,
      :account_terms_and_policies,
      :customer_name,
      :customer_address,
      :project_name,
      :project_description
    )
  end

  def set_account
    @account = @current_user.accounts.find(params[:account_id])
  end

  def set_invoice
    @invoice = @account.find_invoice(params[:id])
  end
end
