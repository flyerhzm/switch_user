require 'spec_helper'

describe "Using SwitchUser", :type => :request do
  let(:user) { User.create!(:email => "foo@bar.com", :admin => true) }
  let(:other_user) { User.create!(:email => "other@bar.com", :admin => false) }
  before do
    SwitchUser.reset_config
    SwitchUser.provider = :session
    SwitchUser.controller_guard = lambda { |current_user, request| Rails.env.test? }
    SwitchUser.redirect_path = lambda {|_,_| "/dummys/open"}
  end
  it "signs a user in using switch_user" do
    # can't access protected url
    get "/dummy/protected"
    response.should be_redirect

    get "/switch_user?scope_identifier=user_#{other_user.id}"
    response.should be_redirect

    # now that we are logged in via switch_user we can access
    get "/dummy/protected"
    response.should be_success
  end
  context "using switch_back" do
    before do
      SwitchUser.switch_back = true
      SwitchUser.controller_guard = lambda { |current_user, request, original_user|
        current_user && current_user.admin? || original_user && original_user.admin?
      }
    end
    it "can switch back to a different user" do
      # login
      post "/login", :id => user.id
      follow_redirect!

      # have SwitchUser remember us
      get "/switch_user/remember_user", :remember => true
      session["original_user_scope_identifier"].should be_present

      # check that we can switch to another user
      get "/switch_user?scope_identifier=user_#{other_user.id}"
      session["user_id"].should == other_user.id

      # logout
      get "/logout"
      session["user_id"].should be_nil

      # check that we can still switch to another user
      get "/switch_user?scope_identifier=user_#{user.id}"
      session["user_id"].should == user.id

      # check that we can be un-remembered
      get "/switch_user/remember_user", :remember => false
      session["original_user"].should be_nil
    end
  end
end
