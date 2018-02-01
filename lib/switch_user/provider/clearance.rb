module SwitchUser
  module Provider
    class Clearance < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, _scope = nil)
        @controller.sign_in(user)
      end

      def logout(_scope = nil)
        @controller.sign_out
      end

      def current_user(_scope = nil)
        @controller.current_user
      end
    end
  end
end
