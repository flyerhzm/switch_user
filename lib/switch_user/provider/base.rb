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

        SwitchUser.available_scopes.each do |scope|
          if requested_scope == scope
            login(user, requested_scope)
          else
            logout(scope)
          end
        end
      end
    end
  end
end
