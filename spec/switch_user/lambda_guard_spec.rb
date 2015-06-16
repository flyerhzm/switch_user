require 'spec_helper'

module SwitchUser
  RSpec.describe LambdaGuard do
    describe "#controller_available?" do
      it "calls the controller_guard proc" do
        controller = double.as_null_object
        provider = double.as_null_object
        guard = SwitchUser::LambdaGuard.new(controller, provider)

        SwitchUser.controller_guard = lambda {|a| a }
        expect(guard).to be_controller_available

        SwitchUser.controller_guard = lambda {|a| !a }
        expect(guard).not_to be_controller_available
      end
    end
  end
end
