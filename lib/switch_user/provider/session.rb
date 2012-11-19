require 'switch_user/provider/base'

module SwitchUser
  module Provider
    class Session < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, scope = nil)
        @controller.session[:user_id] = user.id
      end

      def logout(scope = nil)
        @controller.session.delete(:user_id)
      end

      def current_user(scope = nil)
        @controller.current_user
      end
    end
  end
end
