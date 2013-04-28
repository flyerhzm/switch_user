require 'switch_user/provider/base'

module SwitchUser
  module Provider
    class Devise < Base
      def initialize(controller)
        @controller = controller
        @warden = @controller.warden
      end

      def login(user, scope = :user)
        @warden.set_user(user, :scope => scope)
      end

      def logout(scope = :user)
        clear_original_user
        @warden.logout(scope)
      end

      def current_user(scope = :user)
        @warden.user(scope)
      end
    end
  end
end
