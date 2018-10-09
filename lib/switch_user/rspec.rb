# frozen_string_literal: true

require 'switch_user/rspec/feature_helpers'

require 'rspec/core'

RSpec.configure do |config|
  config.include SwitchUser::RSpecFeatureHelpers, type: :feature

  config.before(:each, type: :feature) do
    allow_any_instance_of(SwitchUserController).to receive(:available?).and_return(true)
  end
end
