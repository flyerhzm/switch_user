require 'support/provider'
require 'support/application'
require 'rspec/rails'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

class ApplicationController < ActionController::Base

end
