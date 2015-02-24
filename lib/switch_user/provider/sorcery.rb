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
        if SwitchUser.switch_back
          save_original_user_identifier
        end

        @controller.logout

        restore_original_user_identifier
      end

      def save_original_user_identifier
        @original_user_scope_identifier = @controller.session[:original_user_scope_identifier]
      end

      def restore_original_user_identifier
        if @original_user_scope_identifier
          @controller.session[:original_user_scope_identifier] = @original_user_scope_identifier
        end
      end

      def current_user(scope = nil)
        @controller.current_user
      end
    end
  end
end
