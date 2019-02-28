# frozen_string_literal: true

module SwitchUser
  module Provider
    class Clearance < Base
      def initialize(controller)
        @controller = controller
      end

      def login(user, _scope = nil)
        @controller.send(:sign_in, user)
      end

      def logout(_scope = nil)
        @controller.send(:sign_out)
      end

      def current_user(_scope = nil)
        @controller.send(:current_user)
      end
    end
  end
end
