require 'spec_helper'

describe "Using SwitchUser", :type => :request do
  it "can load a page" do
    get "/dummys/protected"

    response.should be_redirect
  end
end
