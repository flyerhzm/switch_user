module SwitchUser
  if defined? Rails::Engine
    class Engine < Rails::Engine
      config.to_prepare do
        ActionView::Base.send :include, SwitchUserHelper
      end
    end
  else
    %w(controllers helpers).each do |dir|
      path = File.join(File.dirname(__FILE__), '..', 'app', dir)
      $LOAD_PATH << path
      ActiveSupport::Dependencies.load_paths << path
      ActiveSupport::Dependencies.load_once_paths.delete(path)
      ActionView::Base.send :include, SwitchUserHelper
    end
  end

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
  
  mattr_accessor :allow_guest
  self.allow_guest = true
  
  def self.setup
    yield self
  end
end
