require 'spec_helper'

describe "Using SwitchUser", :type => :request do
  let(:user) { User.create!(:email => "foo@bar.com") }
  before do
    SwitchUser.reset_config
    SwitchUser.provider = :session
    SwitchUser.redirect_path = lambda {|_,_| "/dummys/open"}
  end
  it "can load a page" do
    get "/dummys/protected"
    response.should be_redirect

    get "/switch_user?scope_identifier=user_#{user.id}"
    response.should be_redirect

    get "/dummys/protected"
    response.should be_success
  end
end
