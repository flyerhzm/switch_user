# frozen_string_literal: true

RSpec.shared_examples_for 'a provider' do
  let(:user) { User.create! }
  let(:other_user) { User.create! }

  it 'can log a user in' do
    provider.login(user)

    expect(provider.current_user).to eq user
  end

  it 'can log a user out' do
    provider.login(user)

    provider.logout

    expect(provider.current_user).to eq nil
  end

  it 'responds to login_exclusive' do
    expect(provider).to respond_to(:login_exclusive)
  end

  it 'responds to login_exclusive' do
    expect(provider).to respond_to(:login_inclusive)
  end

  it 'knows if there are any users logged in' do
    provider.login(user, :user)

    expect(provider.current_users_without_scope).to eq [user]
  end

  it 'can lock the original user, allowing us to change current_user' do
    provider.login(user)
    provider.remember_current_user(true)
    provider.login_exclusive(other_user, scope: 'user')

    expect(provider.original_user).to eq user
    expect(provider.current_user(:user)).to eq other_user
  end

  it 'can forget the original_user' do
    provider.login(user)
    provider.remember_current_user(true)

    expect(provider.original_user).to eq user
    provider.remember_current_user(false)

    expect(provider.original_user).to eq nil
  end
end
