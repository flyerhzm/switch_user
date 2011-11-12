module SwitchUserHelper
  def switch_user_select
    if available?
      options = ''
      if SwitchUser.allow_guest
        if current_user
          options += "<option value=''>Guest</option>"
        else
          options += "<option selected='selected' value=''>Guest</option>"
        end
      else
          options += "<option></option>"
      end
      SwitchUser.available_users.each do |scope, user_proc|
        current = send("current_#{scope}")
        identifier = SwitchUser.available_users_identifiers[scope]
        name = SwitchUser.available_users_names[scope]
        user_proc.call.each do |user|
          next if original_user and user.send(identifier) == original_user
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
                 :onchange => "var s=encodeURIComponent(this.options[this.selectedIndex].value);if(!s){return false}location.href = '/switch_user?scope_identifier=' + s"
    end
  end
  
  def switch_back_with_scope_path
    switch_back_path(:scope_identifier => [original_scope, original_user].join('_'))
  end
  
  def original_user
    return nil unless user_session
    user_session[:original_user_id]
  end

  def original_scope
    return nil unless user_session
    user_session[:original_user_scope]
  end

  def available?
    user = nil
    SwitchUser.available_users.keys.each do |scope|
      user = send("current_#{scope}")
      break if user
    end
    SwitchUser.view_guard.call(user, request)
  end
end
