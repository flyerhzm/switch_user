require 'spec_helper'
require 'switch_user/provider/sorcery'

class SorceryController < TestController
  def logout
    @user = nil
  end

  def auto_login(user)
    @user = user
  end

  def current_user
    @user
  end
end

describe SwitchUser::Provider::Sorcery do
  let(:controller) { SorceryController.new }
  let(:provider) { SwitchUser::Provider::Sorcery.new(controller) }

  it_behaves_like "a provider"
end
