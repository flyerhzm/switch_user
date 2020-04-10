# frozen_string_literal: true

require 'spec_helper'
require 'switch_user'
require 'switch_user_controller'

RSpec.describe SwitchUserController, type: :controller do
  before do
    SwitchUser.provider = :dummy
  end

  let(:admin) { double(:admin, admin?: true) }
  let(:provider) { double(:provider, original_user: admin, current_user: nil) }
  describe '#set_current_user' do
    it 'redirects the user to the specified location' do
      SwitchUser.redirect_path = ->(_, _) { '/path' }
      allow(controller).to receive(:available?).and_return(true)
      get :set_current_user, params: { scope_identifier: 'user_1' }

      expect(response).to redirect_to('/path')
    end

    it 'denies access according to the guard block' do
      SwitchUser.controller_guard = ->(_, _, _) { false }
      expect { get :set_current_user }.to raise_error(ActionController::RoutingError)
    end

    describe 'requests with a privileged original_user' do
      before do
        SwitchUser.controller_guard = lambda do |current_user, _, original_user|
          current_user.try(:admin?) || original_user.try(:admin?)
        end
      end
      it 'allows access using the original_user param' do
        allow(controller).to receive(:provider).and_return(provider)

        expect(provider).to receive(:logout_all)

        get :set_current_user

        expect(response).to be_redirect
      end
    end
  end

  describe '#remember_user' do
    before do
      allow(controller).to receive(:provider).and_return(provider)
      SwitchUser.switch_back = true
    end
    it 'can remember the current user' do
      expect(provider).to receive(:remember_current_user).with(true)

      get :remember_user, params: { remember: 'true' }
    end
    it 'can forget the current user' do
      expect(provider).to receive(:remember_current_user).with(false)

      get :remember_user, params: { remember: 'false' }
    end
    it 'does nothing if switch_back is not enabled' do
      SwitchUser.switch_back = false
      expect(provider).not_to receive(:remember_current_user)

      get :remember_user, params: { remember: 'true' }
    end
  end
end
