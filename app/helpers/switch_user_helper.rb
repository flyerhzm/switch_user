module SwitchUserHelper
  def switch_user_select
    if Rails.env == "development"
      if current_user
        options = "<option value="">Guest</option>"
        options += options_from_collection_for_select(User.all, :id, :email, current_user.id)
      else
        options = "<option selected='selected' value="">Guest</option>"
        options += options_from_collection_for_select(User.all, :id, :email)
      end
      select_tag "switch_user_id", options.html_safe, 
                 :onchange => "location.href = '/switch_user?user_id=' + encodeURIComponent(this.options[this.selectedIndex].value)"
    end
  end
end
