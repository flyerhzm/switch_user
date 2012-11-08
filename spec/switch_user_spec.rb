require 'spec_helper'
require 'switch_user'

describe SwitchUser do
  describe "#available_scopes" do
    it "returns a list of available scopes" do
      SwitchUser.available_scopes.should == [:user]
    end
  end

  describe "assigning the provider" do
    it "sets the provider" do
      # ensure we aren't breaking existing functionality
      SwitchUser.provider = :sorcery
      SwitchUser.provider.should == :sorcery
    end
    it "sets the provider class" do
      SwitchUser.provider = :devise
      SwitchUser.provider_class.should == SwitchUser::Provider::Devise
    end
  end

  describe "guards" do
    it "can have a 1 argument lambda" do
      a = 0
      SwitchUser.controller_guard = lambda {|p1| a = p1 }
      SwitchUser.controller_guard(1,2,3)

      a.should == 1
    end
    it "can have a 3 argument lambda" do
      a = 0
      SwitchUser.view_guard = lambda {|p1,p2,p3| a = p3 }
      SwitchUser.view_guard(1,2,3)

      a.should == 3
    end
  end
end
