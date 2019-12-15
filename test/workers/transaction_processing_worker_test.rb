require 'test_helper'

class TransactionProcessingWorkerTest < ActionDispatch::IntegrationTest
  test "Transaction successfully processed" do
    a = Account.create(holder_name: 'alex', balance: 100)
    b = Account.create(holder_name: 'john', balance: 100)
    assert_changes 'Transaction.count' do
      TransactionProcessingWorker.new.perform('uuid', {'from_account_id' => a.id, 'to_account_id' => b.id, 'amount' => 50})
    end
    assert_equal 50, a.reload.balance
    assert_equal 150, b.reload.balance
    assert_equal 'done', Transaction.last.state
  end

  test "Transaction failed" do
    a = Account.create(holder_name: 'alex', balance: 100)
    b = Account.create(holder_name: 'john', balance: 100)
    assert_changes 'Transaction.count' do
      TransactionProcessingWorker.new.perform('uuid', {'from_account_id' => a.id, 'to_account_id' => b.id, 'amount' => 150})
    end
    assert_equal 100, a.balance
    assert_equal 100, b.balance
    assert_equal 'insuficient_funds', Transaction.last.state
  end
end
