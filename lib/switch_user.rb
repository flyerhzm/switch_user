require "rails"

module SwitchUser
  class Engine < Rails::Engine
    config.to_prepare do
      ApplicationController.helper(SwitchUserHelper)
    end
  end

  mattr_accessor :mode
  self.mode = 'devise'

  mattr_accessor :available_users
  self.available_users = { :user => lambda { User.all } }

  mattr_accessor :display_field
  self.display_field = 'email'

  def self.setup
    yield self
  end
end
