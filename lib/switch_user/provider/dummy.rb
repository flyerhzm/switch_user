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

      def original_user
        @original_user
      end

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
