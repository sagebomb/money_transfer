class TransactionsController < ApplicationController
  before_action :set_transaction, only: :show

  def index
    @transactions = Transaction.page(params[:page])

    render 'transactions/index.json'
  end

  def show
    render json: @transaction
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: @transaction, status: :accepted, location: @transaction
    else
      render json: { errors: @transaction.errors }, status: :unprocessable_entity
    end
  end

  private
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:from_account_id, :to_account_id, :amount, :state)
  end
end
