module SwitchUser
  class UserLoader
    attr_reader :scope
    attr_accessor :id

    def self.prepare(*args)
      options = args.extract_options!

      if options[:scope_identifier]
        options[:scope_identifier] =~ /^(.*)_([^_]+)$/
        scope, id = $1, $2
      else
        scope, id = args
      end
      new(scope, id)
    end

    def initialize(scope, id)
      self.scope = scope
      self.id = id
    end

    def user
      user_class.send(finder, id)
    end

    private

    def scope=(scope)
      if scope && SwitchUser.available_scopes.include?(scope.to_sym)
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
