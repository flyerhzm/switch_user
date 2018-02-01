module SwitchUser
  module Provider
    class Session < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, _scope = nil)
        @controller.session[session_key] = user.id
      end

      def logout(_scope = nil)
        @controller.session.delete(session_key)
      end

      def current_user(_scope = nil)
        @controller.current_user
      end

      private

      def session_key
        SwitchUser.session_key
      end
    end
  end
end
