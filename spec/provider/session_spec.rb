# frozen_string_literal: true

require 'spec_helper'
require 'switch_user/provider/session'

class SessionController < TestController
  def current_user
    User.find_by(id: session[:uid]) if session[:uid]
  end
end

RSpec.describe SwitchUser::Provider::Session do
  before { SwitchUser.session_key = :uid }
  let(:controller) { SessionController.new }
  let(:provider) { SwitchUser::Provider::Session.new(controller) }

  it_behaves_like 'a provider'
end
