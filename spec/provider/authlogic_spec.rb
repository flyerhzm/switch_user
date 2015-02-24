require 'spec_helper'
require 'switch_user/provider/authlogic'

class UserSession
  class << self
    attr_accessor :user

    def create(user)
      self.user = user
    end

    def destroy
      self.user = nil
    end

    def find
      self
    end

    def record
      user
    end
  end
end

class AuthlogicController < TestController
  def current_user_session
    UserSession
  end
end

describe SwitchUser::Provider::Authlogic do
  let(:controller) { AuthlogicController.new }
  let(:provider) { SwitchUser::Provider::Authlogic.new(controller) }

  it_behaves_like "a provider"
end
