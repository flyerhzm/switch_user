require_relative '../spec_helper'
require 'provider/authlogic'

class UserSession
  class << self
    attr_accessor :user

    def create(user)
      self.user = user
    end

    def destroy
      self.user = nil
    end

    def find
      self
    end

    def record
      user
    end
  end
end

class AuthlogicController
  def current_user_session
    UserSession
  end
end

describe Provider::Authlogic do
  let(:controller) { AuthlogicController.new }
  let(:provider) { Provider::Authlogic.new(controller) }
  let(:user) { stub(:user) }

  it "can log a user in" do
    provider.login(user)

    provider.current_user.should == user
  end

  it "can log a user out" do
    provider.login(user)

    provider.logout

    provider.current_user.should == nil
  end

  it "knows the current_user" do

  end
end
