class TransactionProcessingWorker
  include Sidekiq::Worker

  # Public: Process transaction
  #
  # id - The Integer id of transaction to process
  #
  # Examples
  #
  #   TransactionProcessigWorker.perform_async(1)
  #
  # Returns nothing.
  def perform(id)
    transaction = Transaction.find(id)

    Account.transaction do
      from   = transaction.from_account
      to     = transaction.to_account
      amount = transaction.amount
      # why do I perform 2 #lock! calls here? I just want to make it more generic for some reason haha.
      # There's no necessity for the second #lock! for sqlite (since it doesn't have any row locking mechanism, the whole file is locked instead) 
      # The table has already been locked, so it'll be just ignored.
      # But for pg (for example) #lock! obtains FOR UPDATE row lock to prevent race conditions, that's why we would need both.
      from.lock!
      return transaction.insuficient_funds! unless from.hold(amount)

      to.lock!
      to.top_up(amount)

      from.save!
      to.save!
      transaction.done!
    end
  end
end
