require 'spec_helper'

module SwitchUser
  describe Provider do
    it "initializes the provider" do
      SwitchUser.provider = :dummy
      Provider.init(stub(:controller)).should be_a(Provider::Dummy)
    end
  end
end
