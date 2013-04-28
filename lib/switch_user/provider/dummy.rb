require 'switch_user/provider/base'

module SwitchUser
  module Provider
    class Dummy < Base
      def initialize(controller)
        @user = nil
      end

      def login(user, scope = nil)
        @user = user
      end

      def logout(scope = nil)
        @user = nil
        @original_user = nil
      end

      def current_user(scope = nil)
        @user
      end

      def original_user
        @original_user
      end

      def lock_user!
        @original_user = @user
      end
    end
  end
end
