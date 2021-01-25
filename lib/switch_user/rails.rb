# frozen_string_literal: true

module SwitchUser
  class Engine < Rails::Engine
    initializer 'switch_user.view' do
      config.to_prepare { ActiveSupport.on_load(:action_view) { include SwitchUserHelper } }
    end
  end
end
