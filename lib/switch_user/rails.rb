module SwitchUser
  class Engine < Rails::Engine
    initializer "switch_user.view" do
      ActiveSupport.on_load(:action_view) do
        include SwitchUserHelper
      end
    end
  end
end
