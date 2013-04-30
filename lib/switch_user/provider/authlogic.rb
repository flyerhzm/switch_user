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
