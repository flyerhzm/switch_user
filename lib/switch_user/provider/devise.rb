# frozen_string_literal: true

module SwitchUser
  module Provider
    class Devise < Base
      def initialize(controller)
        @controller = controller
        @warden = @controller.warden
      end

      def login(user, scope = nil)
        if SwitchUser.provider.is_a?(Hash) && SwitchUser.provider[:store_sign_in]
          @warden.set_user(user, scope: scope)
        else
          @warden.session_serializer.store(user, scope)
        end
      end

      def logout(scope = nil)
        @warden.logout(scope)
      end

      def current_user(scope = nil)
        @warden.user(scope)
      end
    end
  end
end
