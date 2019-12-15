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
    # I pass uuid here to return something to the user
    # user will be able to query transaction status using the uuid
    transaction_uuid = SecureRandom.uuid
    @transaction = Transaction.new(transaction_params) do |t|
      t.uuid = transaction_uuid
    end
    if @transaction.valid?
      TransactionProcessingWorker.perform_async(transaction_uuid, transaction_params.to_unsafe_h) # sidekiq doesn't support permitted params
      render json: { uuid: transaction_uuid }, status: :accepted
    else
      render json: { error: @transaction.errors }, status: :unprocessable_entity
    end
  end

  private
  def set_transaction
    @transaction = Transaction.where('uuid = :id or id = :id', id: params[:id]).first!
  end

  def transaction_params
    params.require(:transaction).permit(:from_account_id, :to_account_id, :amount)
  end
end
