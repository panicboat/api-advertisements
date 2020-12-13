require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Concepts', 'concepts'
end
if ENV['CODECOV_TOKEN'].present?
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

Rails.application.eager_load!

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require 'webmock'
WebMock.enable!

class ActiveSupport::TestCase
  include Trailblazer::Test::Assertions
  include Trailblazer::Test::Operation::Assertions
  include Trailblazer::Test::Operation::Helper

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)
  # TODO: https://github.com/simplecov-ruby/simplecov/issues/718
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end
