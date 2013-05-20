module SwitchUserHelper
  class SelectOption < Struct.new(:label, :scope_id); end
  def switch_user_select
    return unless available?
    options = []
    selected_user = nil

    options << SelectOption.new("Guest", "") if SwitchUser.helper_with_guest
    SwitchUser.available_users.each do |scope, user_proc|
      current_user = provider.current_user(scope)
      id_name = SwitchUser.available_users_identifiers[scope]
      name = SwitchUser.available_users_names[scope]

      user_proc.call.each do |user|
        if user == current_user
          selected_user = tag_value(user, id_name, scope)
        end
        options << SelectOption.new(tag_label(user, name), tag_value(user, id_name, scope))
      end
    end

    render :partial => "switch_user/widget",
           :locals => {
             :options => options,
             :current_scope => selected_user
           }
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
    SwitchUser.guard_class.new(controller, provider).view_available?
  end

  def provider
    SwitchUser::Provider.init(controller)
  end
end
