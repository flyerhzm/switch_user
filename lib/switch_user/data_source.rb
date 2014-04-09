module SwitchUser
  DataSource = Struct.new(:loader, :scope, :identifier, :name) do
    def users
      loader.call.map {|u| Record.new(u, self) }
    end
  end

  GuestRecord = Struct.new(:scope) do
    def equivalent?(other_scope_id)
      scope_id == other_scope_id
    end

    def label
      "Guest"
    end

    def scope_id
    end
  end

  class GuestDataSource
    def initialize(name)
      @name = name
    end

    def users
      [ GuestRecord.new(self) ]
    end
  end

  DataSources = Struct.new(:sources) do
    def users
      sources.flat_map {|source| source.users }
    end

    def find_scope_id(scope_id)
      users.flat_map.detect {|u| u.scope_id == scope_id }
    end
  end

  Record = Struct.new(:user, :source) do
    def equivalent?(other_scope_id)
      scope_id == other_scope_id
    end

    def scope_id
      "#{source.scope}_#{user.send(source.identifier)}"
    end

    def label
      user.send(source.name)
    end

    def scope
      source.scope
    end
  end
end
