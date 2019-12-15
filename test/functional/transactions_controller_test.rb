require 'test_helper'
require 'sidekiq/testing' 

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_a = Account.create holder_name: 'A', balance: 100
    @account_b = Account.create holder_name: 'B', balance: 100
  end

  test "index returns list of transactions with right structure and pagination info" do
    get transactions_url

    assert_response :success
    assert parsed_body.has_key? 'data'
    assert parsed_body.has_key? 'page'
    assert parsed_body.has_key? 'total_pages'
  end

  test 'show the resource' do
    t = Transaction.create from_account: @account_a, to_account: @account_b, amount: 10, uuid: '1'
    get transaction_url(id: t.id)
    assert_response :success
    assert_equal @response.body, t.to_json
  end

  test 'lookup the resource by uuid' do
    t = Transaction.create from_account: @account_a, to_account: @account_b, amount: 10, uuid: '1'
    get transaction_url(id: t.uuid)
    assert_response :success
    assert_equal @response.body, t.to_json
  end


  test 'you cannot see what does not exist' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get transaction_url(id: 100)
    end
  end

  test 'transaction creation' do
    assert_equal 0, TransactionProcessingWorker.jobs.size
    assert_no_changes 'Transaction.count' do
      post transactions_url, params: { transaction: { from_account_id: @account_b.id, to_account_id: @account_a.id, amount: 100 } }
    end

    assert_response :accepted
    assert_not_empty @response.body #uuid
    assert_equal 1, TransactionProcessingWorker.jobs.size
  end

  test 'transaction creation errors' do
    TransactionProcessingWorker.clear
    assert_no_changes 'Transaction.count' do
      post transactions_url, params: { transaction: { to_account_id: @account_a.id, amount: 100 } }
    end

    assert_response :unprocessable_entity
    assert parsed_body.has_key? 'error'
    assert parsed_body['error'].has_key? 'from_account'
    assert_equal 0, TransactionProcessingWorker.jobs.size
  end
end
