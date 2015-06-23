module SwitchUser
  class DataSources
    attr_reader :sources

    def initialize(sources)
      @sources = sources
    end

    def all
      sources.flat_map { |source| source.all }
    end

    def find_scope_id(scope_id)
      sources.map {|source| source.find_scope_id(scope_id) }.compact.first
    end
  end

  class DataSource
    attr_reader :loader, :scope, :identifier, :name

    def initialize(loader, scope, identifier, name)
      @loader = loader
      @scope = scope
      @identifier = identifier
      @name = name
    end

    def all
      loader.call.select(identifier, name).map { |user| Record.new(user, self) }
    end

    def find_scope_id(scope_id)
      user = loader.call.find_by identifier => scope_id.delete("#{scope}_")
      Record.new(user, self)
    end
  end

  class GuestDataSource
    def all
      [ GuestRecord.new ]
    end

    def find_scope_id(scope_id)
    end
  end

  class Record
    attr_reader :user, :source

    def initialize(user, source)
      @user = user
      @source = source
    end

    def label
      user.send(source.name)
    end

    def scope
      source.scope
    end

    def scope_id
      "#{source.scope}_#{user.send(source.identifier)}"
    end
  end

  class GuestRecord
    def label
      "Guest"
    end

    def scope_id
    end
  end
end
