require 'switch_user/provider/base'

module SwitchUser
  module Provider
    class Authlogic < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, scope = nil)
        UserSession.create(user)
      end

      def logout(scope = nil)
        clear_original_user
        @controller.current_user_session.destroy
      end

      def current_user(scope = nil)
        result = UserSession.find
        if result
          result.record
        end
      end
    end
  end
end
