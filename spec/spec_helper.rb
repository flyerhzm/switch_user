ENV["RAILS_ENV"] = "test"
require 'support/provider'
require 'support/application'
require 'rspec/rails'
require 'switch_user'
require 'pry'
require 'awesome_print'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = true
end

class TestController
  def session
    @session_hash ||= {}
  end

  def reset_session
    @session_hash = {}
  end
end
