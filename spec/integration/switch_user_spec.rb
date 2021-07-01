# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Using SwitchUser', type: :request do
  let(:user) { User.create!(email: 'foo@bar.com', admin: true) }
  let(:other_user) { User.create!(email: 'other@bar.com', admin: false) }

  before do
    SwitchUser.reset_config
    SwitchUser.provider = :session
    SwitchUser.controller_guard = ->(_current_user, _request) { Rails.env.test? }
    SwitchUser.redirect_path = ->(_, _) { '/dummy/open' }
  end

  it 'signs a user in using switch_user' do
    # can't access protected url
    get '/dummy/protected'
    expect(response).to be_redirect

    get "/switch_user?scope_identifier=user_#{other_user.id}"
    expect(response).to be_redirect

    # now that we are logged in via switch_user we can access
    get '/dummy/protected'
    expect(response).to be_success
  end

  context 'using switch_back' do
    before do
      SwitchUser.switch_back = true
      SwitchUser.controller_guard =
        lambda do |current_user, _request, original_user|
          current_user && current_user.admin? || original_user && original_user.admin?
        end
    end

    it 'can switch back to a different user through remember_user endpoint' do
      # login
      post '/login', params: { id: user.id }
      follow_redirect!

      # have SwitchUser remember us
      get '/switch_user/remember_user', params: { remember: true }
      expect(session['original_user_scope_identifier']).to be_present

      # check that we can switch to another user
      get "/switch_user?scope_identifier=user_#{other_user.id}"
      expect(session['user_id']).to eq other_user.id

      # logout
      get '/logout'
      expect(session['user_id']).to be_nil

      # check that we can still switch to another user
      get "/switch_user?scope_identifier=user_#{user.id}"
      expect(session['user_id']).to eq user.id

      # check that we can be un-remembered
      get '/switch_user/remember_user', params: { remember: false }
      expect(session['original_user']).to be_nil
    end

    it 'can switch back to a different user without hitting remember_user endpoint' do
      # login
      post '/login', params: { id: user.id }
      follow_redirect!

      # check that we can switch to another user
      get "/switch_user?scope_identifier=user_#{other_user.id}", params: { remember: true }
      expect(session['user_id']).to eq other_user.id
      expect(session['original_user_scope_identifier']).to_not be_nil

      # logout
      get '/logout'
      expect(session['user_id']).to be_nil

      # check that we can still switch to another user
      get "/switch_user?scope_identifier=user_#{user.id}"
      expect(session['user_id']).to eq user.id

      # check that we can be un-remembered
      get '/switch_user/remember_user', params: { remember: false }
      expect(session['original_user']).to be_nil
    end

    context 'when non-default identifier' do
      before { SwitchUser.available_users_identifiers = { user: :email } }

      after { SwitchUser.available_users_identifiers = { user: :id } }

      it 'can switch back to a different user through remember_user endpoint' do
        # login
        post '/login', params: { id: user.id }
        follow_redirect!

        # have SwitchUser remember us
        get '/switch_user/remember_user', params: { remember: true }
        expect(session['original_user_scope_identifier']).to be_present

        # check that we can switch to another user
        get "/switch_user?scope_identifier=user_#{other_user.email}"
        expect(session['user_id']).to eq other_user.id

        # logout
        get '/logout'
        expect(session['user_id']).to be_nil

        # check that we can still switch to another user
        get "/switch_user?scope_identifier=user_#{user.email}"
        expect(session['user_id']).to eq user.id

        # check that we can be un-remembered
        get '/switch_user/remember_user', params: { remember: false }
        expect(session['original_user']).to be_nil
      end

      it 'can switch back to a different user without hitting remember_user endpoint' do
        # login
        post '/login', params: { id: user.id }
        follow_redirect!

        # check that we can switch to another user
        get "/switch_user?scope_identifier=user_#{other_user.email}", params: { remember: true }
        expect(session['user_id']).to eq other_user.id
        expect(session['original_user_scope_identifier']).to_not be_nil

        # logout
        get '/logout'
        expect(session['user_id']).to be_nil

        # check that we can still switch to another user
        get "/switch_user?scope_identifier=user_#{user.email}"
        expect(session['user_id']).to eq user.id

        # check that we can be un-remembered
        get '/switch_user/remember_user', params: { remember: false }
        expect(session['original_user']).to be_nil
      end
    end
  end
end
