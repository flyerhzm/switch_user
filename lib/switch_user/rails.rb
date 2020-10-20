# frozen_string_literal: true

module SwitchUser
  class Engine < Rails::Engine
    initializer 'switch_user.view' do
      config.to_prepare do
        ActiveSupport.on_load(:action_view) do
          include SwitchUserHelper
        end
      end
    end
  end
end
