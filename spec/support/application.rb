require "rails"
require "rails/all"
require 'switch_user/rails'


class ApplicationController < ActionController::Base
  def require_user
    current_user || redirect_to("/tests/open")
  end

  def current_user
    User.find_by_id(session[SwitchUser.session_key])
  end

  def login
    user = User.find(params[:id])
    session[SwitchUser.session_key] = user.id

    redirect_to("/tests/protected")
  end

  def logout
    session[SwitchUser.session_key] = nil
  end
end

class DummyController < ApplicationController
  before_filter :require_user, :only => :protected

  def authenticated
    render :text => current_user.inspect
  end

  def open
    render :text => view_context.switch_user_select
  end

  def protected
    render :text => view_context.switch_user_select
  end
end

module MyApp
  class Application < Rails::Application
    config.active_support.deprecation = :log
    config.secret_key_base = "abc123"
    config.eager_load = true
    config.secret_token = '153572e559247c7aedd1bca5a246874d'
  end
end
Rails.application.initialize!
Rails.application.routes.draw do
  get 'dummy/protected', :to => "dummy#protected"
  get 'dummy/open', :to => "dummy#open"
  post 'login', :to => "dummy#login"
  get 'logout', :to => "dummy#logout"
  get 'authenticated', :to => "dummy#authenticated"
  get :switch_user, :to => 'switch_user#set_current_user'
  get 'switch_user/remember_user', :to => 'switch_user#remember_user'
end

connection = ActiveRecord::Base.connection
connection.create_table :users do |t|
  t.column :email, :string
  t.column :admin, :boolean
end

class User < ActiveRecord::Base
end
