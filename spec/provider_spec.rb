require 'spec_helper'

module SwitchUser
  RSpec.describe Provider do
    it 'initializes the provider' do
      SwitchUser.provider = :dummy
      expect(Provider.init(double(:controller))).to be_a(Provider::Dummy)
    end
  end
end
