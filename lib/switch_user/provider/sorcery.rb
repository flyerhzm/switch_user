require 'switch_user/provider/base'

module SwitchUser
  module Provider
    class Sorcery < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, scope = nil)
        @controller.auto_login(user)
      end

      def logout(scope = nil)
        clear_original_user
        @controller.logout
      end

      def current_user(scope = nil)
        @controller.current_user
      end
    end
  end
end
