module SwitchUser
  module Provider
    class Base
      def login_exclusive(user, args)
        requested_scope = args.fetch(:scope, :user)
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
