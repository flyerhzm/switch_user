require 'switch_user/data_source'

module SwitchUser
  describe DataSource do
    it "can load users" do
      loader = lambda { [ double, double] }
      source = DataSource.new(loader, :user, :id, :email)

      source.users.should have(2).records
    end
  end

  describe DataSources do
    it "aggregates multiple data_sources" do
      user = double(:user)
      s1 = double(:s1, :users => [user])
      source = DataSources.new([s1,s1])

      source.users.should == [user, user]
    end

    describe "#find_source_id" do
      it "can find a corresponding record across data sources" do
        user = double(:user, :scope_id => "user_10")
        s1 = double(:s1, :users => [])
        s2 = double(:s1, :users => [user])
        source = DataSources.new([s1,s2])

        source.find_scope_id("user_10").should == user
      end
    end
  end

  describe Record do
    it "can be compared to a identifier string" do
      id1 = "user_100"
      id2 = "user_101"
      id3 = "staff_100"
      user = double(:user, :id => 100, :email => "test@example.com")
      source = DataSource.new(nil, :user, :id, :email)

      record = Record.new(user, source)

      record.should be_equivalent(id1)
      record.should_not be_equivalent(id2)
      record.should_not be_equivalent(id3)
    end
  end
end
