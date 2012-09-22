require_relative '../spec_helper'
require 'provider/sorcery'

class SorceryController
  def logout
    @user = nil
  end

  def auto_login(user)
    @user = user
  end

  def current_user
    @user
  end
end

describe Provider::Sorcery do
  let(:controller) { SorceryController.new }
  let(:provider) { Provider::Sorcery.new(controller) }
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
