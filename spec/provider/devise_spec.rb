require_relative '../spec_helper'
require 'provider/devise'

class FakeWarden
  attr_reader :user

  def initialize
    @user = nil
  end

  def set_user(user, args)
    @user = user
  end

  def logout(scope)
    @user = nil
  end
end

class DeviseController
  def warden
    @warden ||= FakeWarden.new
  end

  def current_user
    @warden.user
  end
end

describe Provider::Devise do
  let(:controller) { DeviseController.new }
  let(:provider) { Provider::Devise.new(controller) }
  let(:user) { stub(:user) }

  it "can log a user in" do
    provider.login(user)

    provider.current_user.should == user
  end

  it "can log a user out" do
    provider.login(user)

    provider.logout

    controller.current_user.should == nil
  end

  it "knows the current_user" do

  end
end
