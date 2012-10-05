require 'spec_helper'
require 'switch_user/provider/devise'

class FakeWarden
  attr_reader :user_hash

  def initialize
    @user_hash = {}
  end

  def set_user(user, args)
    scope = args.fetch(:scope, :user)
    @user_hash[scope] = user
  end

  def logout(scope)
    @user_hash.delete(scope)
  end
end

class DeviseController
  def warden
    @warden ||= FakeWarden.new
  end

  def current_user
    @warden.user_hash[:user]
  end

  def current_admin
    @warden.user_hash[:admin]
  end
end

describe SwitchUser::Provider::Devise do
  let(:controller) { DeviseController.new }
  let(:provider) { SwitchUser::Provider::Devise.new(controller) }

  it_behaves_like "a provider"

  it "can use alternate scopes" do
    user = stub(:user)
    provider.login(user, :admin)

    provider.current_user(:admin).should == user
  end

  describe "#login_exclusive" do
    let(:user) { stub(:user) }
    before do
      SwitchUser.stub(:available_users => {:user => nil, :admin => nil})
      provider.login(user, :admin)
      provider.login_exclusive(user, :scope => :user)
    end
    it "logs the user in" do
      provider.current_user.should == user
    end
    it "logs out other scopes" do
      provider.current_user(:admin).should be_nil
    end
  end
end
