require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "index returns list of accounts with right structure and pagination info" do
    get accounts_url

    assert_response :success
    assert parsed_body.has_key? 'data'
    assert parsed_body.has_key? 'page'
    assert parsed_body.has_key? 'total_pages'
  end

  test 'show the resource' do
    account = Account.create(holder_name: 'a', balance: 100)
    get account_url(account)
    assert_response :success
    assert_equal @response.body, account.to_json
  end

  test 'you cannot see what does not exist' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get account_url(id: 100)
    end
  end

  test 'account creation' do
    assert_changes 'Account.count' do
      post accounts_url, params: { account: { holder_name: 'alex', balance: 100 } }
    end

    assert_response :created
    assert_equal @response.body, Account.last.to_json
  end

  test 'account creation errors' do
    assert_no_changes 'Account.count' do
      post accounts_url, params: { account: { balance: 100 } }
    end

    assert_response :unprocessable_entity
    assert parsed_body.has_key? 'error'
    assert parsed_body['error'].has_key? 'holder_name'
  end
end
