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
      user_class.where(column_name => id).first
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

    def column_name
      SwitchUser.available_users_identifiers[scope.to_sym]
    end
  end
end
