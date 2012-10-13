module SwitchUserHelper
  def switch_user_select
    return unless available?
    options = ""

    options += content_tag(:option, "Guest", :value => "", :selected => !current_user)
    SwitchUser.available_users.each do |scope, user_proc|
      current_user = provider.current_user(scope)
      identifier = SwitchUser.available_users_identifiers[scope]
      name = SwitchUser.available_users_names[scope]

      user_proc.call.each do |user|
        if current_user == user
          options += content_tag(:option,
                                 current_user.send(name),
                                 :value => "#{scope}_#{current_user.send(identifier)}",
                                 :selected => true)
        else
          options += content_tag(:option,
                                 user.send(name),
                                 :value => "#{scope}_#{user.send(identifier)}")
        end
      end
    end

    if options.respond_to?(:html_safe)
      options = options.html_safe
    end
    select_tag "switch_user_identifier", options,
      :onchange => "location.href = '/switch_user?scope_identifier=' + encodeURIComponent(this.options[this.selectedIndex].value)"
  end

  def available?
    user = provider.current_users_without_scope.first
    SwitchUser.view_guard.call(user, request)
  end

  def provider
    SwitchUser.provider_class.new(controller)
  end
end
