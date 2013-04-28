require 'spec_helper'
require 'switch_user/provider/restful_authentication'

class RestfulAuthenticationController < TestController
  attr_accessor :current_user

  def logout_killing_session!
    self.current_user = nil
  end
end

describe SwitchUser::Provider::RestfulAuthentication do
  let(:controller) { RestfulAuthenticationController.new }
  let(:provider) { SwitchUser::Provider::RestfulAuthentication.new(controller) }

  it_behaves_like "a provider"
end
