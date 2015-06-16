require 'switch_user/data_source'

module SwitchUser
  RSpec.describe DataSource do
    it "can load users" do
      loader = lambda { [ double, double] }
      source = DataSource.new(loader, :user, :id, :email)

      expect(source.users.size).to eq 2
    end
  end

  RSpec.describe DataSources do
    it "aggregates multiple data_sources" do
      user = double(:user)
      s1 = double(:s1, :users => [user])
      source = DataSources.new([s1,s1])

      expect(source.users).to eq [user, user]
    end

    describe "#find_source_id" do
      it "can find a corresponding record across data sources" do
        user = double(:user, :scope_id => "user_10")
        s1 = double(:s1, :users => [])
        s2 = double(:s1, :users => [user])
        source = DataSources.new([s1,s2])

        expect(source.find_scope_id("user_10")).to eq user
      end
    end
  end

  RSpec.describe Record do
    it "can be compared to a identifier string" do
      id1 = "user_100"
      id2 = "user_101"
      id3 = "staff_100"
      user = double(:user, :id => 100, :email => "test@example.com")
      source = DataSource.new(nil, :user, :id, :email)

      record = Record.new(user, source)

      expect(record).to be_equivalent(id1)
      expect(record).not_to be_equivalent(id2)
      expect(record).not_to be_equivalent(id3)
    end
  end
end
