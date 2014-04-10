module SwitchUser
  class UserSet
    def self.init_from_config
      SwitchUser.available_users.map do |scope, base_scope|
        identifier = SwitchUser.available_users_identifiers[scope]
        label      = SwitchUser.available_users_names[scope]
        new(scope, identifier, label, base_scope)
      end
    end

    def self.users
      init_from_config.flat_map {|user_set|
        user_set.users.map {|user| Record.build(user, user_set) }
      }
    end

    attr_reader :scope, :user_class, :identifier, :label, :base_scope
    def initialize(scope, identifier, label, base_scope)
      @scope      = scope
      @user_class = normalize_class(scope)
      @identifier = identifier
      @label      = label
      @base_scope = normalize_scope(base_scope)
    end

    def find_user(id)
      Record.build(users.where(:id => id).first, self)
    end
    alias :[] :find_user

    def users
      base_scope
    end

    private

    def normalize_class(klass)
      if klass.is_a?(Class)
        klass
      else
        klass.to_s.classify.constantize
      end
    end

    def normalize_scope(scope)
      if scope.respond_to?(:call)
        scoped = scope.call
        if scoped.respond_to?(:scoped)
          scoped
        else
          user_class.respond_to?(:scoped) ? user_class.scoped : user_class.all
        end
      else
        user_class.respond_to?(:scoped) ? user_class.scoped : user_class.all
      end
    end
    class Record < Struct.new(:id, :label, :scope)
      def self.build(user, set)
        id    = user.send(set.identifier)
        label = user.send(set.label)
        scope = set.scope

        new(id, label, scope)
      end

      def scope_id
        "#{scope}_#{id}"
      end
    end
  end
end
