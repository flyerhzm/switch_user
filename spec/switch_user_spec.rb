require 'spec_helper'
require 'switch_user'

RSpec.describe SwitchUser do
  describe "#available_scopes" do
    it "returns a list of available scopes" do
      expect(SwitchUser.available_scopes).to eq [:user]
    end
  end

  describe "assigning the provider" do
    it "sets the provider" do
      # ensure we aren't breaking existing functionality
      SwitchUser.provider = :sorcery
      expect(SwitchUser.provider).to eq :sorcery
    end
  end
end
