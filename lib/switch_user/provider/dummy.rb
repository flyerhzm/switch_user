module SwitchUser
  module Provider
    class Dummy < Base
      def initialize(_controller)
        @user = nil
      end

      def login(user, _scope = nil)
        @user = user
      end

      def logout(_scope = nil)
        @user = nil
      end

      def current_user(_scope = nil)
        @user
      end

      attr_reader :original_user

      def remember_current_user(remember)
        @original_user = (current_user if remember)
      end
    end
  end
end
