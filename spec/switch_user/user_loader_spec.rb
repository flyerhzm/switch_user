require 'spec_helper'
require 'switch_user/user_loader'

class User
  def self.find_by_id(id)
  end
end

describe SwitchUser::UserLoader do
  let(:user) { stub(:user) }

  it "raises an exception if we are passed an invalid scope" do
    expect { SwitchUser::UserLoader.new("useeer", 1) }.to raise_error(SwitchUser::InvalidScope)
  end

  it "returns a user" do
    User.stub(:find_by_id).with(1).and_return(user)

    loader = SwitchUser::UserLoader.new("user", 1)

    loader.user.should == user
  end

  it "returns nil if no user is found" do
    loader = SwitchUser::UserLoader.new("user", 2)
    loader.user.should == nil
  end

  it "loads a user with an alternate identifier column" do
    User.stub(:find_by_email).with(2).and_return(user)
    SwitchUser.available_users_identifiers = {:user => :email}

    loader = SwitchUser::UserLoader.new("user", 2)
    loader.user.should == user
  end
end
