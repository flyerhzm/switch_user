require 'spec_helper'
require 'switch_user/provider/session'

class SessionController < TestController
  def current_user
    User.find_by_id(session[:uid]) if session[:uid]
  end
end

describe SwitchUser::Provider::Session do
  before do
    user.stub(:id => 100)
    User.stub(:find_by_id).with(100).and_return(user)
    User.stub(:find_by_id).with(101).and_return(other_user)
    SwitchUser.session_key = :uid
  end
  let(:controller) { SessionController.new }
  let(:provider) { SwitchUser::Provider::Session.new(controller) }

  it_behaves_like "a provider"
end
