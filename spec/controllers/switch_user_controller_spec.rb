require 'spec_helper'
require 'switch_user'
require 'switch_user_controller'

describe SwitchUserController, :type => :controller do
  before do
    SwitchUser.provider = :dummy
  end

  it "redirects the user to the specified location" do
    SwitchUser.redirect_path = lambda {|_,_| "/path"}
    controller.stub(:available? => true)
    get :set_current_user, :scope_identifier => "user_1"

    response.should redirect_to("/path")
  end

  it "denies access according to the guard block" do
    SwitchUser.controller_guard = lambda {|_,_| false }
    get :set_current_user

    response.should be_forbidden
  end
end
