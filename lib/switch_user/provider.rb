module SwitchUser
  module Provider
    autoload :Base, "switch_user/provider/base"
    autoload :Authlogic, "switch_user/provider/authlogic"
    autoload :Clearance, "switch_user/provider/clearance"
    autoload :Devise, "switch_user/provider/devise"
    autoload :RestfulAuthentication, "switch_user/provider/restful_authentication"
    autoload :Sorcery, "switch_user/provider/sorcery"
    autoload :Dummy, "switch_user/provider/dummy"
    autoload :Session, "switch_user/provider/session"

    def self.init(controller)
      klass_part = SwitchUser.provider.to_s.classify
      klass    = "SwitchUser::Provider::#{klass_part}".constantize

      klass.new(controller)
    end
  end
end
