if defined?(Rails)
  require 'switch_user/rails'
end

module SwitchUser
  autoload :UserLoader, "switch_user/user_loader"
  autoload :Provider, "switch_user/provider"
  autoload :BaseGuard, "switch_user/base_guard"
  autoload :LambdaGuard, 'switch_user/lambda_guard'

  class InvalidScope < Exception; end

  mattr_accessor :provider
  mattr_accessor :available_users
  mattr_accessor :available_users_identifiers
  mattr_accessor :available_users_names
  mattr_accessor :redirect_path
  mattr_accessor :session_key
  mattr_accessor :helper_with_guest
  mattr_accessor :switch_back
  mattr_accessor :login_exclusive
  mattr_accessor :controller_guard
  mattr_accessor :view_guard
  mattr_reader   :guard_class

  def self.setup
    yield self
  end

  def self.available_scopes
    available_users.keys
  end

  def self.guard_class=(klass)
    @@guard_class = klass.constantize
  end

  private

  def self.reset_config
    self.provider = :devise
    self.available_users = { :user => lambda { User.all } }
    self.available_users_identifiers = { :user => :id }
    self.available_users_names = { :user => :email }
    self.guard_class = "SwitchUser::LambdaGuard"
    self.controller_guard = lambda { |current_user, request| Rails.env.development? }
    self.view_guard = lambda { |current_user, request| Rails.env.development? }
    self.redirect_path = lambda { |request, params| request.env["HTTP_REFERER"] ? :back : root_path }
    self.session_key = :user_id
    self.helper_with_guest = true
    self.switch_back = false
    self.login_exclusive = true
  end

  reset_config
end
