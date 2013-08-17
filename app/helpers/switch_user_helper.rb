module SwitchUserHelper
  class SelectOption < Struct.new(:label, :scope_id); end
  def switch_user_select
    return unless available?
    options = []
    selected_user = nil

    users = SwitchUser::UserSet.users
    users << SelectOption.new("Guest", "") if SwitchUser.helper_with_guest
    render :partial => "switch_user/widget",
           :locals => {
             :options => users,
             :current_scope => selected_user
           }
  end

  private

  def user_tag_value(user, id_name, scope)
    identifier = user.send(id_name)

    "#{scope}_#{identifier}"
  end

  def user_tag_label(user, name)
    name.respond_to?(:call) ? name.call(user) : user.send(name)
  end

  def available?
    SwitchUser.guard_class.new(controller, provider).view_available?
  end

  def provider
    SwitchUser::Provider.init(controller)
  end
end
