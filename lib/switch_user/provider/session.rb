require 'switch_user/provider/base'

module SwitchUser
  module Provider
    class Session < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, scope = nil)
        @controller.session[session_key] = user.id
      end

      def logout(scope = nil)
        clear_original_user
        @controller.session.delete(session_key)
      end

      def current_user(scope = nil)
        @controller.current_user
      end

      private

      def session_key
        SwitchUser.session_key
      end
    end
  end
end
