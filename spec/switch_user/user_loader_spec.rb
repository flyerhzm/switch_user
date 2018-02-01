require 'spec_helper'
require 'switch_user/user_loader'

RSpec.describe SwitchUser::UserLoader do
  let(:user) { double(:user) }
  let(:user_result) { [user] }

  it 'raises an exception if we are passed an invalid scope' do
    expect { SwitchUser::UserLoader.new('useeer', 1) }.to raise_error(SwitchUser::InvalidScope)
  end

  describe '.user' do
    before do
      SwitchUser.available_users_identifiers = { user: :id }
      allow(User).to receive(:where).with(id: '1').and_return(user_result)
    end
    it 'can be loaded from a scope and identifier' do
      loaded_user = SwitchUser::UserLoader.prepare('user', '1').user

      expect(loaded_user).to eq user
    end
    it 'can be loaded by a passing an unprocessed scope identifier' do
      loaded_user = SwitchUser::UserLoader.prepare(scope_identifier: 'user_1').user

      expect(loaded_user).to eq user
    end
    it 'raises an error for an invalid scope' do
      expect {
        loaded_user = SwitchUser::UserLoader.prepare(nil, '1')
      }.to raise_error(SwitchUser::InvalidScope)
    end
  end

  it 'returns a user' do
    allow(User).to receive(:where).with(id: 1).and_return(user_result)

    loader = SwitchUser::UserLoader.new('user', 1)

    expect(loader.user).to eq user
  end

  it 'returns nil if no user is found' do
    loader = SwitchUser::UserLoader.new('user', 3)

    expect(User.find_by_id(3)).to be_nil
    expect(loader.user).to eq nil
  end

  it 'loads a user with an alternate identifier column' do
    allow(User).to receive(:where).with(email: 2).and_return(user_result)
    SwitchUser.available_users_identifiers = { user: :email }

    loader = SwitchUser::UserLoader.new('user', 2)
    expect(loader.user).to eq user
  end
end
