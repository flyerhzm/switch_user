require "rails"

module SwitchUser
  class Engine < Rails::Engine
    config.to_prepare do
        ApplicationController.helper(SwitchUserHelper)
    end
  end
end