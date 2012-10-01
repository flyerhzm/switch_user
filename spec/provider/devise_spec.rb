require 'spec_helper'
require 'switch_user/provider/devise'

class FakeWarden
  attr_reader :user

  def initialize
    @user = nil
  end

  def set_user(user, args)
    @user = user
  end

  def logout(scope)
    @user = nil
  end
end

class DeviseController
  def warden
    @warden ||= FakeWarden.new
  end

  def current_user
    @warden.user
  end
end

describe SwitchUser::Provider::Devise do
  let(:controller) { DeviseController.new }
  let(:provider) { SwitchUser::Provider::Devise.new(controller) }

  it_behaves_like "a provider"
end
