module SwitchUser
  module Provider
    class Base
      def current_users_without_scope
        SwitchUser.available_scopes.inject([]) do |users, scope|
          user = current_user(scope)
          users << user if user
          users
        end
      end

      def login_exclusive(user, args)
        requested_scope = args.fetch(:scope, :user).to_sym

        logout_all
        login(user, requested_scope)
      end

      def logout_all
        SwitchUser.available_scopes.each do |scope|
          logout(scope)
        end
      end
    end
  end
end
