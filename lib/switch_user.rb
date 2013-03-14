require 'switch_user/rails'
require 'switch_user/provider'
require 'active_support/core_ext'

module SwitchUser
  autoload :UserLoader, "switch_user/user_loader"

  class InvalidScope < Exception; end

  mattr_accessor :provider
  mattr_accessor :available_users
  mattr_accessor :available_users_identifiers
  mattr_accessor :available_users_names
  mattr_writer :controller_guard
  mattr_writer :view_guard
  mattr_accessor :redirect_path
  mattr_accessor :session_key
  mattr_accessor :helper_with_guest

  def self.setup
    yield self
  end

  def self.provider_class
    "SwitchUser::Provider::#{provider.to_s.classify}".constantize
  end

  def self.available_scopes
    available_users.keys
  end

  def self.controller_guard(*args)
    call_guard(@@controller_guard, args)
  end

  def self.view_guard(*args)
    call_guard(@@view_guard, args)
  end

  private

  def self.reset_config
    self.provider = :devise
    self.available_users = { :user => lambda { User.all } }
    self.available_users_identifiers = { :user => :id }
    self.available_users_names = { :user => :email }
    self.controller_guard = lambda { |current_user, request| Rails.env.development? }
    self.view_guard = lambda { |current_user, request| Rails.env.development? }
    self.redirect_path = lambda { |request, params| request.env["HTTP_REFERER"] ? :back : root_path }
    self.session_key = :user_id
    self.helper_with_guest = true
  end

  def self.call_guard(guard, args)
    arity = guard.arity
    guard.call(*args[0...arity])
  end

  reset_config
end
