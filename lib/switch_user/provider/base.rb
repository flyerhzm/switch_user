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

      def login_inclusive(user, args)
        requested_scope = args.fetch(:scope, :user).to_sym

        logout(requested_scope)
        login(user, requested_scope)
      end

      def logout_all
        SwitchUser.available_scopes.each do |scope|
          logout(scope)
        end
      end

      def original_user
        @controller.session[:original_user]
      end

      def remember_current_user(remember)
        if remember
          @controller.session[:original_user] = current_user
        else
          @controller.session.delete(:original_user)
        end
      end

      def clear_original_user
        @controller.session.delete(:original_user)
      end
    end
  end
end
