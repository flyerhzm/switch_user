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
  mattr_accessor :controller_guard
  mattr_accessor :view_guard
  mattr_accessor :redirect_path

  def self.setup
    yield self
  end

  def self.provider_class
    "SwitchUser::Provider::#{provider.to_s.classify}".constantize
  end

  def self.available_scopes
    available_users.keys
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
  end

  reset_config
end
