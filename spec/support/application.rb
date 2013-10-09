require "rails"
require "rails/all"

class ApplicationController < ActionController::Base
  def require_user
    session[:current_user] || redirect_to("/tests/open")
  end
end

class DummysController < ApplicationController
  before_filter :require_user, :only => :protected

  def open
    render :text => "open"
  end

  def protected
    render :text => "protected"
  end
end

module MyApp
  class Application < Rails::Application
    config.active_support.deprecation = :log
    config.threadsafe!
    config.secret_key_base = "abc123"
    config.eager_load = true
    config.secret_token = '153572e559247c7aedd1bca5a246874d'
  end
end
Rails.application.initialize!
Rails.application.routes.draw do
  get 'dummys/protected', :to => "dummys#protected"
  get 'dummys/open', :to => "dummys#open"
  get :switch_user, :to => 'switch_user#set_current_user'
  get 'switch_user/remember_user', :to => 'switch_user#remember_user'
end

connection = ActiveRecord::Base.connection
connection.create_table :users do |t|
  t.column :email, :string
end

class User < ActiveRecord::Base
end
