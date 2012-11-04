require "rails"
require "rails/all"

class MyApp < Rails::Application
  config.active_support.deprecation = :log
end
MyApp.initialize!
