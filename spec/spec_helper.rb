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

connection = ActiveRecord::Base.connection
connection.create_table :users do |t|
  t.column :email, :string
end

class User < ActiveRecord::Base
end
