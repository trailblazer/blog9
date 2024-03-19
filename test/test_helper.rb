ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/spec"
# require "trailblazer/workflow/testing" # {#assert_position}

class Minitest::Spec
  # # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  include Trailblazer::Test::Assertions

  def assert_equal(actual, expected, *args)
    super(expected, actual, *args)
  end
end
