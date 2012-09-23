require 'spec_helper'
require 'provider/restful_authentication'

class RestfulAuthenticationController
  attr_accessor :current_user

  def logout_killing_session!
    self.current_user = nil
  end
end

describe Provider::RestfulAuthentication do
  let(:controller) { RestfulAuthenticationController.new }
  let(:provider) { Provider::RestfulAuthentication.new(controller) }

  it_behaves_like "a provider"
end
