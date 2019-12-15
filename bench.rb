require 'excon'
require 'json'
require 'parallel'

operations = []
10.times { |t| operations[t] = [] }
1000.times { |t| operations[t%10] << t }

Parallel.each(operations, in_processes: 10) do |ids|
  Parallel.each(ids, in_threads: 100) do |i|
    Excon.post('http://localhost:3000/transactions/', :body => {transaction: { from_account_id: i, to_account_id: i+1, amount: 1000 }}.to_json, :headers => { "Content-Type" => "application/json" })
    Excon.post('http://localhost:3000/transactions/', :body => {transaction: { from_account_id: i, to_account_id: i+1, amount: 1000 }}.to_json, :headers => { "Content-Type" => "application/json" })
  end
end
