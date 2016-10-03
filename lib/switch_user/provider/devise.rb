module SwitchUser
  module Provider
    class Devise < Base
      def initialize(controller)
        @controller = controller
        @warden = @controller.warden
      end

      def login(user, scope = :user)
        if SwitchUser.provider.is_a?(Hash) && SwitchUser.provider[:store_sign_in]
          @warden.set_user(user, scope: scope)
        else
          @warden.session_serializer.store(user, scope)
        end
      end

      def logout(scope = :user)
        @warden.logout(scope)
      end

      def current_user(scope = :user)
        @warden.user(scope)
      end
    end
  end
end
