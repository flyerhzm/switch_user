require 'switch_user/rails'
require 'switch_user/provider'
require 'active_support/core_ext'

module SwitchUser
  mattr_accessor :provider
  self.provider = :devise

  mattr_accessor :available_users
  self.available_users = { :user => lambda { User.all } }

  mattr_accessor :available_users_identifiers
  self.available_users_identifiers = { :user => :id }

  mattr_accessor :available_users_names
  self.available_users_names = { :user => :email }

  mattr_accessor :controller_guard
  self.controller_guard = lambda { |current_user, request| Rails.env.development? }
  mattr_accessor :view_guard
  self.view_guard = lambda { |current_user, request| Rails.env.development? }

  mattr_accessor :redirect_path
  self.redirect_path = lambda { |request, params| request.env["HTTP_REFERER"] ? :back : root_path }

  def self.setup
    yield self
  end
end
