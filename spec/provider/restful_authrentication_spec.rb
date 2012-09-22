require_relative '../spec_helper'
require 'provider/restful_authentication'

class RestfulAuthenticationController
  attr_accessor :current_user

  def logout_killing_session!
    self.current_user = nil
  end
end

describe Provider::RestfulAuthentication do
  let(:controller) { RestfulAuthenticationController.new }
  let(:provider) { Provider::RestfulAuthentication.new(controller) }
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
