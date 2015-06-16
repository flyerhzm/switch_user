require 'spec_helper'
require 'switch_user/user_set'

module SwitchUser
  RSpec.describe UserSet do
    let!(:user) { User.create(:email => "test@example.com") }
    let(:set) { UserSet.new(:user, :id, :email, lambda { User.all }) }
    after { User.delete_all }
    it "returns an object that knows it's scope, id and label" do
      found_user = set[user.id]

      expect(found_user.id).to eq user.id
      expect(found_user.scope).to eq :user
      expect(found_user.label).to eq "test@example.com"
    end
    it "returns all available users for a scope" do
      expect(set.users).to eq [user]
    end
    it "chains the where on to the provided scope" do
      set = UserSet.new(:user, :id, :email, lambda { User.all })
      expect(set.find_user(user.id).label).to eq user.email
    end
  end
  RSpec.describe UserSet::Record do
    it "correctly configures the record using the set" do
      user = double(:user, :id => 100, :email => "test@example.com")
      set = double(:set, :identifier  => :id, :label => :email, :scope => :user)
      record = UserSet::Record.build(user, set)
      expect(record.id).to eq 100
      expect(record.label).to eq "test@example.com"
      expect(record.scope).to eq :user
    end
  end
end
