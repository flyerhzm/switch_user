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
        user_identifier = @controller.session[:original_user_scope_identifier]

        if user_identifier
          UserLoader.prepare(:scope_identifier => user_identifier).user
        end
      end

      def original_user=(user)
        user_type       = user.class.to_s.underscore
        user_identifier = "#{user_type}_#{user.id}"

        @controller.session[:original_user_scope_identifier] = user_identifier
      end

      def remember_current_user(remember)
        if remember
          self.original_user = current_user
        else
          clear_original_user
        end
      end

      def clear_original_user
        @controller.session.delete(:original_user_scope_identifier)
      end

      def current_user?(user, scope = :user)
        current_user(scope) == user
      end

    end
  end
end
