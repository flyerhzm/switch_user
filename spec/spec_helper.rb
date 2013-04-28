require 'support/provider'
require 'support/application'
require 'rspec/rails'
require 'switch_user'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

class ApplicationController < ActionController::Base

end

class TestController
  def session
    @session_hash ||= {}
  end
end

class User
  def self.where(*)
    []
  end
end

