# frozen_string_literal: true

require 'spec_helper'
require 'switch_user/provider/devise'

class FakeWardenSessionSerializer
  attr_accessor :user_hash

  def store(user, scope)
    return unless user
    user_hash[scope] = user
  end
end

class FakeWarden
  attr_reader :user_hash

  def initialize
    @user_hash = {}
  end

  def set_user(user, args)
    scope = args.fetch(:scope, :user)
    @user_hash[scope] = user
  end

  def session_serializer
    serializer = FakeWardenSessionSerializer.new
    serializer.user_hash = @user_hash
    serializer
  end

  def user(scope)
    @user_hash[scope]
  end

  def logout(scope)
    @user_hash.delete(scope)
  end
end

class DeviseController < TestController
  def warden
    @warden ||= FakeWarden.new
  end

  def current_user
    @warder.user
  end
end

RSpec.describe SwitchUser::Provider::Devise do
  let(:controller) { DeviseController.new }
  let(:provider) { SwitchUser::Provider::Devise.new(controller) }
  let(:user) { double(:user) }

  it_behaves_like 'a provider'

  it 'can use alternate scopes' do
    user = double(:user)
    provider.login(user, :admin)

    expect(provider.current_user(:admin)).to eq user
  end

  describe '#login_exclusive' do
    before do
      allow(SwitchUser).to receive(:available_users).and_return(user: nil, admin: nil)
      provider.login(user, :admin)
      provider.login_exclusive(user, scope: 'user')
    end

    it 'logs the user in' do
      expect(provider.current_user(:user)).to eq user
    end

    it 'logs out other scopes' do
      expect(provider.current_user(:admin)).to be_nil
    end
  end

  describe '#logout_all' do
    it 'logs out users under all scopes' do
      allow(SwitchUser).to receive(:available_users).and_return(user: nil, admin: nil)
      provider.login(user, :admin)
      provider.login(user, :user)

      provider.logout_all

      expect(provider.current_user(:admin)).to be_nil
      expect(provider.current_user(:user)).to be_nil
    end
  end

  describe '#all_current_users' do
    it 'pulls users from an alternate scope' do
      allow(SwitchUser).to receive(:available_users).and_return(user: nil, admin: nil)
      provider.login(user, :admin)

      expect(provider.current_users_without_scope).to eq [user]
    end
  end

  describe '#current_user?' do
    it 'logs the user in' do
      user = double(:user)
      provider.login(user, :user)

      expect(provider.current_user?(user, :user)).to eq true
      expect(provider.current_user?(user, :admin)).to eq false
    end
  end
end
