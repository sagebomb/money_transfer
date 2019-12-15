class TransactionProcessingWorker
  include Sidekiq::Worker

  def perform(uuid, params)
    from   = Account.find(params['from_account_id'])
    to     = Account.find(params['to_account_id'])
    amount = BigDecimal(params['amount'])
    transaction = Transaction.new(amount: amount, from_account: from, to_account: to, uuid: uuid)
    Account.transaction do
      # why do I perform 2 #lock! calls here? I just want to make it more generic (for some reason) haha.
      # There's no necessity for the second #lock! with sqlite (since it doesn't have any row locking mechanism, the whole file is locked instead) 
      # The table has already been locked, so it'll be just ignored.
      #
      # But for pg (for example) #lock! obtains FOR UPDATE row lock to prevent race conditions, that's why we would need both.
      # with pg/mysql this style of locking may lead to a deadlock condition
      # so it does make sense to set appropriate lock timeout
      # sidekiq will restart job automatically
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
