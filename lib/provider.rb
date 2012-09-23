module SwitchUser
  autoload :Authlogic, "switch_user/provider/authlogic"
  autoload :Devise, "switch_user/provider/devise"
  autoload :RestfulAuthentication, "switch_user/provider/restful_authentication"
  autoload :Sorcery, "switch_user/provider/sorcery"
end
