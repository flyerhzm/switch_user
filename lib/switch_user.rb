if defined?(Rails)
  require 'switch_user/rails'
end

module SwitchUser
  autoload :UserLoader, "switch_user/user_loader"
  autoload :Provider, "switch_user/provider"

  class InvalidScope < Exception; end

  mattr_accessor :provider
  mattr_accessor :available_users
  mattr_accessor :available_users_identifiers
  mattr_accessor :available_users_names
  mattr_accessor :redirect_path
  mattr_accessor :session_key
  mattr_accessor :helper_with_guest
  mattr_accessor :switch_back

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
  mattr_writer :controller_guard

  def self.view_guard(*args)
    call_guard(@@view_guard, args)
  end
  mattr_writer :view_guard

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
    self.switch_back = false
  end

  def self.call_guard(guard, args)
    arity = guard.arity
    guard.call(*args[0...arity])
  end

  reset_config
end
