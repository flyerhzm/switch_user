if defined?(Rails)
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
end
