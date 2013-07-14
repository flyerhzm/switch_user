module SwitchUserHelper
  class SelectOption < Struct.new(:label, :scope_id); end
  def switch_user_select
    return unless available?
    options = []
    selected_user = nil

    options << SelectOption.new("Guest", "") if SwitchUser.helper_with_guest

    # returns an array of UserSet::Records, which is a wrapper around a user
    # type object which remembers the config it was derived from.
    options.concat(SwitchUser::UserSet.users)

    render :partial => "switch_user/widget",
           :locals => {
             :options => options,
             :current_scope => selected_user
           }
  end

  private

  def available?
    SwitchUser.guard_class.new(controller, provider).view_available?
  end

  def provider
    SwitchUser::Provider.init(controller)
  end
end
