require 'spec_helper'
require 'provider/authlogic'

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

class AuthlogicController
  def current_user_session
    UserSession
  end
end

describe Provider::Authlogic do
  let(:controller) { AuthlogicController.new }
  let(:provider) { Provider::Authlogic.new(controller) }

  it_behaves_like "a provider"
end
