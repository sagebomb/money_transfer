require 'simplecov'
SimpleCov.start('rails') do
  add_filter 'app/controllers/application_controller.rb' #empty
end
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors)

  def parsed_body
    JSON.parse @response.body
  end
end
