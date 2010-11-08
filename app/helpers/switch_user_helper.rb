module SwitchUserHelper
  def switch_user_select
    if Rails.env == "development"
      options = send("#{SwitchUser.provider}_select_options")
      select_tag "switch_user_id", options.html_safe, 
                 :onchange => "location.href = '/switch_user?scope_id=' + encodeURIComponent(this.options[this.selectedIndex].value)"
    end
  end

  private
    def devise_select_options
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
      options
    end
end
