module SwitchUserHelper
  def switch_user_select
    if available?
      if current_user
        options = "<option value=''>Guest</option>"
      else
        options = "<option selected='selected' value=''>Guest</option>"
      end
      SwitchUser.available_users.each do |scope, user_proc|
        current = send("current_#{scope}")
        identifier = SwitchUser.available_users_identifiers[scope]
        name = SwitchUser.available_users_names[scope]
        user_proc.call.each do |user|
          if current and current.send(identifier) == user.send(identifier)
            options += "<option selected='selected' value='#{scope}_#{user.send(identifier)}'>#{user.send(name)}</option>"
          else
            options += "<option value='#{scope}_#{user.send(identifier)}'>#{user.send(name)}</option>"
          end
        end
      end
      if options.respond_to?(:html_safe)
        options = options.html_safe
      end
      select_tag "switch_user_identifier", options,
                 :onchange => "location.href = '/switch_user?scope_identifier=' + encodeURIComponent(this.options[this.selectedIndex].value)"
    end
  end

  def available?
    user = nil
    SwitchUser.available_users.keys.each do |scope|
      user = send("current_#{scope}")
      break if user
    end
    SwitchUser.view_guard.call(self)
  end
end
