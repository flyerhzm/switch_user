module SwitchUser
  class UserLoader
    attr_reader :scope
    attr_accessor :id

    def initialize(scope, id)
      self.scope = scope
      self.id = id
    end

    def load
      user_class.send(finder, id)
    end

    private

    def scope=(scope)
      if SwitchUser.available_scopes.include?(scope.to_sym)
        @scope = scope
      else
        raise InvalidScope
      end
    end

    def user_class
      scope.classify.constantize
    end

    def finder
      column_name = SwitchUser.available_users_identifiers[scope.to_sym]

      "find_by_#{column_name}"
    end
  end
end
