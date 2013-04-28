require 'spec_helper'
require 'switch_user/provider/clearance'

class ClearanceController < TestController
  def sign_in(user)
    @user = user
  end

  def sign_out
    @user = nil
  end

  def current_user
    @user
  end
end

describe SwitchUser::Provider::Clearance do
  let(:controller) { ClearanceController.new }
  let(:provider) { SwitchUser::Provider::Clearance.new(controller) }

  it_behaves_like "a provider"
end
