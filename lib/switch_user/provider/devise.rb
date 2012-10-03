module SwitchUser
  module Provider
    class Devise
      def initialize(controller)
        @controller = controller
        @warden = @controller.warden
      end

      def login(user, scope = :user)
        @warden.set_user(user, :scope => scope)
      end

      def logout(scope = :user)
        @warden.logout(scope)
      end

      def current_user(scope = :user)
        @controller.send("current_#{scope}")
      end
    end
  end
end
