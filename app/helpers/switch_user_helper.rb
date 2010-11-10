module SwitchUserHelper
  def switch_user_select
    if available?
      if current_user
        options = "<option value=''>Guest</option>"
      else
        options = "<option selected='selected' value=''>Guest</option>"
      end
      SwitchUser.available_users.each do |scope, user_proc|
        user_proc.call.each do |user|
          current = send("current_#{scope}")
          if current and current.id == user.id
            options += "<option selected='selected' value='#{scope}_#{user.id}'>#{user.send(SwitchUser.display_field)}</option>"
          else
            options += "<option value='#{scope}_#{user.id}'>#{user.send(SwitchUser.display_field)}</option>"
          end
        end
      end
      if Rails.version =~ /^3/
        options = options.html_safe
      end
      select_tag "switch_user_id", options,
                 :onchange => "location.href = '/switch_user?scope_id=' + encodeURIComponent(this.options[this.selectedIndex].value)"
    end
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
