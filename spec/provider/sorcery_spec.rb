require 'spec_helper'
require 'provider/sorcery'

class SorceryController
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

describe Provider::Sorcery do
  let(:controller) { SorceryController.new }
  let(:provider) { Provider::Sorcery.new(controller) }

  it_behaves_like "a provider"
end
