require 'spec_helper'
require 'switch_user'
require 'switch_user_controller'

describe SwitchUserController, :type => :controller do
  before do
    SwitchUser.provider = :dummy
  end

  let(:admin) { double(:admin, :admin? => true) }
  let(:provider) { double(:provider,
                        :original_user => admin,
                        :current_user => nil)
  }
  describe "#set_current_user" do
    it "redirects the user to the specified location" do
      SwitchUser.redirect_path = lambda {|_,_| "/path"}
      allow(controller).to receive(:available?).and_return(true)
      get :set_current_user, :scope_identifier => "user_1"

      response.should redirect_to("/path")
    end

    it "denies access according to the guard block" do
      SwitchUser.controller_guard = lambda {|_,_,_| false }
      get :set_current_user

      response.should be_forbidden
    end

    describe "requests with a privileged original_user" do
      before do
        SwitchUser.controller_guard = lambda {|current_user, _, original_user|
          current_user.try(:admin?) || original_user.try(:admin?)
        }
      end
      it "allows access using the original_user param" do
        allow(controller).to receive(:provider).and_return(provider)

        provider.should_receive(:logout_all)

        get :set_current_user

        response.should be_redirect
      end
    end
  end

  describe "#remember_user" do
    before do
      allow(controller).to receive(:provider).and_return(provider)
      SwitchUser.switch_back = true
    end
    it "can remember the current user" do
      provider.should_receive(:remember_current_user).with(true)

      get :remember_user, :remember => "true"
    end
    it "can forget the current user" do
      provider.should_receive(:remember_current_user).with(false)

      get :remember_user, :remember => "false"
    end
    it "does nothing if switch_back is not enabled" do
      SwitchUser.switch_back = false
      provider.should_not_receive(:remember_current_user)

      get :remember_user, :remember => "true"
    end
  end
end
