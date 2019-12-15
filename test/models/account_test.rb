require 'test_helper'

class AccountTest < ActiveSupport::TestCase
   test "Account creation" do
     assert Account.create(holder_name: 'Name', balance: 100)
   end

   test "Balance is zero by default" do
     account = Account.create(holder_name: 'Name')
     assert_equal 0, account.balance
   end

   test "Balance cant be below zero" do
     account = Account.new(holder_name: 'Name', balance: -1)
     assert_not account.save
   end

   test "Account should belong to someone" do
     account = Account.new(balance: -1)
     assert_not account.save
   end

   test "It is impossible to hold more money than available" do
     account = Account.create(holder_name: 'Name', balance: 100)
     assert_not account.hold(200)
   end

   test "It is possible to hold lesser amount than you got" do
     account = Account.create(holder_name: 'Name', balance: 100)
     account.hold(50)
     assert_equal 50, account.balance
   end

   test "It is pretty easy to top up your balance" do
     account = Account.create(holder_name: 'Name', balance: 100)
     account.top_up(50)
     assert_equal 150, account.balance
   end
end
