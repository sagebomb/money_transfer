require 'test_helper'
require 'sidekiq/testing' 

class TransactionProcessingTest < ActionDispatch::IntegrationTest
  test "Valid http post request creates a job which will be processed in background" do
    a = Account.create(holder_name: 'alex', balance: 100)
    b = Account.create(holder_name: 'john', balance: 100)
    Sidekiq::Testing.inline! do
      assert_changes 'Transaction.count' do
        post transactions_url, params: { transaction: { from_account_id: a.id, to_account_id: b.id, amount: 10 } }
      end
    end
    assert_equal 90, a.reload.balance
    assert_equal 110, b.reload.balance
    assert_equal 'done', Transaction.last.state
  end

  test "Valid http post request with incorrect amount creates a job which will be processed in background" do
    a = Account.create(holder_name: 'alex', balance: 100)
    b = Account.create(holder_name: 'john', balance: 100)
    Sidekiq::Testing.inline! do
      assert_changes 'Transaction.count' do
        post transactions_url, params: { transaction: { from_account_id: a.id, to_account_id: b.id, amount: 110 } }
      end
    end
    assert_equal 100, a.reload.balance
    assert_equal 100, b.reload.balance
    assert_equal 'insuficient_funds', Transaction.last.state
  end
end
