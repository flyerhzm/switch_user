# frozen_string_literal: true

module SwitchUser
  module Provider
    class Sorcery < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, _scope = nil)
        @controller.auto_login(user)
      end

      def logout(_scope = nil)
        save_original_user_identifier if SwitchUser.switch_back

        @controller.logout

        restore_original_user_identifier
      end

      def save_original_user_identifier
        @original_user_scope_identifier = @controller.session[:original_user_scope_identifier]
      end

      def restore_original_user_identifier
        @controller.session[:original_user_scope_identifier] = @original_user_scope_identifier if @original_user_scope_identifier
      end

      def current_user(_scope = nil)
        @controller.current_user
      end
    end
  end
end
