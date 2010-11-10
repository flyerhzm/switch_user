require "rails"

module SwitchUser
  class Engine < Rails::Engine
    config.to_prepare do
      ApplicationController.helper(SwitchUserHelper)
    end
  end

  mattr_accessor :provider
  self.provider = :devise

  mattr_accessor :available_users
  self.available_users = { :user => lambda { User.all } }

  mattr_accessor :display_field
  self.display_field = :email

  mattr_accessor :controller_guard
  self.controller_guard = lambda { Rails.env == "development" }
  mattr_accessor :view_guard
  self.view_guard = lambda { Rails.env == "development" }

  mattr_accessor :redirect_path
  self.redirect_path = lambda { |request| request.env["HTTP_REFERER"] ? :back : root_path }

  def self.setup
    yield self
  end
end
