require 'spec_helper'

module SwitchUser
  describe LambdaGuard do
    describe "#controller_available?" do
      it "calls the controller_guard proc" do
        controller = stub.as_null_object
        provider = stub.as_null_object
        guard = SwitchUser::LambdaGuard.new(controller, provider)

        SwitchUser.controller_guard = lambda {|a| a }
        guard.should be_controller_available

        SwitchUser.controller_guard = lambda {|a| !a }
        guard.should_not be_controller_available
      end
    end
  end
end
