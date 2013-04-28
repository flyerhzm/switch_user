require 'spec_helper'
require 'switch_user/provider/dummy'

class SessionController < TestController
end

describe SwitchUser::Provider::Session do
  let(:controller) { SessionController.new }
  let(:provider) { SwitchUser::Provider::Dummy.new(controller) }

  it_behaves_like "a provider"
end
