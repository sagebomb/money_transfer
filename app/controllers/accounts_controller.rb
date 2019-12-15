class AccountsController < ApplicationController
  before_action :set_account, only: :show

  def index
    @accounts = Account.page(params[:page])

    render 'accounts/index.json'
  end

  def show
    render json: @account
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      render json: @account, status: :created, location: @account
    else
      render json: { error: @account.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:number, :holder_name, :balance)
  end
end
