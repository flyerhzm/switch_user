module SwitchUser
  module Generators
    class InstallGenerator < Rails::Generators::Base
      TEMPLATES_PATH = File.expand_path('../templates', __FILE__)
      source_root File.expand_path(Engine.root, __FILE__)

      def install_initializer
        copy_file "#{TEMPLATES_PATH}/switch_user.rb", 'config/initializers/switch_user.rb'
      end
    end
  end
end

