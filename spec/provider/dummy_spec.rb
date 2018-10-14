# frozen_string_literal: true

require 'spec_helper'
require 'switch_user/provider/dummy'

class SessionController < TestController
end

RSpec.describe SwitchUser::Provider::Session do
  let(:controller) { SessionController.new }
  let(:provider) { SwitchUser::Provider::Dummy.new(controller) }

  it_behaves_like 'a provider'
end
