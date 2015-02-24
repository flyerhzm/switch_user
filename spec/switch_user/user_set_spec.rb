require 'spec_helper'
require 'switch_user/user_set'

module SwitchUser
  describe UserSet do
    let!(:user) { User.create(:email => "test@example.com") }
    let(:set) { UserSet.new(:user, :id, :email, lambda { User.all }) }
    after { User.delete_all }
    it "returns an object that knows it's scope, id and label" do
      found_user = set[user.id]

      found_user.id.should == user.id
      found_user.scope.should == :user
      found_user.label.should == "test@example.com"
    end
    it "returns all available users for a scope" do
      set.users.should == [user]
    end
    it "chains the where on to the provided scope" do
      set = UserSet.new(:user, :id, :email, lambda { User.all })
      set.find_user(user.id).label.should == user.email
    end
  end
  describe UserSet::Record do
    it "correctly configures the record using the set" do
      user = double(:user, :id => 100, :email => "test@example.com")
      set = double(:set, :identifier  => :id, :label => :email, :scope => :user)
      record = UserSet::Record.build(user, set)
      record.id.should == 100
      record.label.should == "test@example.com"
      record.scope.should == :user
    end
  end
end
