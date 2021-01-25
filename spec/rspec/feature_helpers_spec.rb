# frozen_string_literal: true

require 'spec_helper'

require 'capybara/rspec'
require 'capybara/rails'
Capybara.app = MyApp::Application

require 'switch_user/rspec'

RSpec.feature 'SwitchUser::RSpecFeatureHelpers', type: :feature do
  background do
    @user = User.create!(email: 'foo@bar.com', admin: true)
    @client = Client.create!(email: 'foo@bar.com')
  end

  before(:example) do
    allow(SwitchUser).to receive(:controller_guard).and_return(->(_current_user, _request) { true })

    allow(SwitchUser).to receive(:available_users).and_return(user: -> { User.all })

    allow(SwitchUser).to receive(:available_users_identifiers).and_return(user: :id)

    allow(SwitchUser).to receive(:available_users_names).and_return(user: :email)
  end

  scenario 'when controller_guard return false' do
    allow(SwitchUser).to receive(:controller_guard).and_return(->(_current_user, _request) { false })

    expect { switch_user @user }.not_to raise_error
  end

  scenario 'when controller_guard return false and controller call original available?' do
    allow(SwitchUser).to receive(:controller_guard).and_return(->(_current_user, _request) { false })

    allow_any_instance_of(SwitchUserController).to receive(:available?).and_call_original

    expect { switch_user @user }.to raise_error ActionController::RoutingError, /Do not try to hack us/
  end

  scenario 'arg is @user, available_users is default, and available_users_identifiers is default' do
    expect { switch_user @user }.not_to raise_error
  end

  scenario 'arg is @user, available_users is default, and available_users_identifiers is {user: id}' do
    allow(SwitchUser).to receive(:available_users_identifiers).and_return(user: :id)

    expect { switch_user @user }.not_to raise_error
  end

  scenario 'arg is @user, available_users is default, and available_users_identifiers is {:client => :id}' do
    allow(SwitchUser).to receive(:available_users_identifiers).and_return(client: :id)
    allow(SwitchUser).to receive(:available_users_names).and_return(client: :email)

    expect { switch_user @user }.to raise_error SwitchUser::InvalidScope, /config.available_users_identifiers/
  end

  scenario 'arg is @client, available_users is default, and available_users_identifiers is default' do
    expect { switch_user @client }.to raise_error SwitchUser::InvalidScope, /config.available_users/
  end

  scenario 'arg is @client, available_users is {:user => lambda { User.all }, :client => lambda {Client.all}}, and available_users_identifiers is default' do
    allow(SwitchUser).to receive(:available_users).and_return(user: -> { User.all }, client: -> { Client.all })

    expect { switch_user @client }.to raise_error SwitchUser::InvalidScope, /config.available_users_identifiers/
  end

  scenario 'arg is @client, available_users is {:user => lambda { User.all }, :client => lambda {Client.all}}, and available_users_identifiers is {:user => id, :client => id}' do
    allow(SwitchUser).to receive(:available_users).and_return(user: -> { User.all }, client: -> { Client.all })

    allow(SwitchUser).to receive(:available_users_identifiers).and_return(user: :id, client: :id)
    allow(SwitchUser).to receive(:available_users_names).and_return(user: :email, client: :email)

    expect { switch_user @client }.not_to raise_error
  end

  scenario 'args is :user and @user.id, available_users is default, and available_users_identifiers is default' do
    expect { switch_user :user, @user.id }.not_to raise_error
  end

  scenario 'arg is :client and @client.id, available_users is default, and available_users_identifiers is default' do
    expect { switch_user :client, @client.id }.to raise_error SwitchUser::InvalidScope, /config.available_users/
  end

  scenario 'args is :user, available_users is default, and available_users_identifiers is default' do
    expect { switch_user :user }.to raise_error SwitchUser::RSpecFeatureHelpers::InvalidArgument, /user_id is empty/
  end

  scenario 'args is :user and nil, available_users is default, and available_users_identifiers is default' do
    expect { switch_user :user, nil }.to raise_error SwitchUser::RSpecFeatureHelpers::InvalidArgument,
                /user_id is empty/
  end

  scenario "args is :user and '', available_users is default, and available_users_identifiers is default" do
    expect { switch_user :user, '' }.to raise_error SwitchUser::RSpecFeatureHelpers::InvalidArgument, /user_id is empty/
  end

  scenario 'args is :user and 0, available_users is default, and available_users_identifiers is default' do
    expect { switch_user :user, 0 }.not_to raise_error
  end
end
