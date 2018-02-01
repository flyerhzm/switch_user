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
      end

      def current_user(scope = nil)
        @user
      end

      attr_reader :original_user

      def remember_current_user(remember)
        if remember
          @original_user = current_user
        else
          @original_user = nil
        end
      end
    end
  end
end
