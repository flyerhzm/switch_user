module SwitchUserHelper
  def switch_user_select
    return unless available?
    options = ""

    options += content_tag(:option, "Guest", :value => "", :selected => !current_user)
    SwitchUser.available_users.each do |scope, user_proc|
      current_user = provider.current_user(scope)
      id_name = SwitchUser.available_users_identifiers[scope]
      name = SwitchUser.available_users_names[scope]

      user_proc.call.each do |user|
        user_match = (user == current_user)
        options += content_tag(:option,
                               tag_label(user, name),
                               :value => tag_value(user, id_name, scope),
                               :selected => user_match)
      end
    end

    if options.respond_to?(:html_safe)
      options = options.html_safe
    end
    select_tag "switch_user_identifier", options,
      :onchange => "location.href = '/switch_user?scope_identifier=' + encodeURIComponent(this.options[this.selectedIndex].value)"
  end

  private

  def tag_value(user, id_name, scope)
    identifier = user.send(id_name)

    "#{scope}_#{identifier}"
  end

  def tag_label(user, name)
    user.send(name)
  end

  def available?
    user = provider.current_users_without_scope.first
    SwitchUser.view_guard.call(user, request)
  end

  def provider
    SwitchUser.provider_class.new(controller)
  end
end
