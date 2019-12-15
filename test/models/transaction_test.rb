require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  setup do
    @account_a = Account.create holder_name: 'A', balance: 100
    @account_b = Account.create holder_name: 'B', balance: 100
  end

  test "Transaction creation? Easy breeze lemon squeezy" do
    t = Transaction.new from_account: @account_a, to_account: @account_b, amount: 10, uuid: '1'
    assert t.save
   end

  test 'Transaction default state is created' do
    t = Transaction.create from_account: @account_a, to_account: @account_b, amount: 10, uuid: '1'
    assert_equal t.state, 'created'
  end

  test 'Transaction cannot survive without uuid!' do
    t = Transaction.new from_account: @account_a, to_account: @account_b, amount: 10
    assert_not t.save
  end

  test 'You cannot perform transaction with negative or zero amount' do
    t = Transaction.new from_account: @account_a, to_account: @account_b, amount: 0
    t1 = Transaction.new from_account: @account_a, to_account: @account_b, amount: -1
    assert_not t.save
    assert_not t1.save
  end
end
