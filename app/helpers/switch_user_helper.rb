# frozen_string_literal: true

module SwitchUserHelper
  SelectOption = Struct.new(:label, :scope_id)

  def switch_user_select(options = {})
    return unless available?

    selected_user = nil

    grouped_options_container = {}.tap do |h|
      SwitchUser.all_users.each do |record|
        scope = record.is_a?(SwitchUser::GuestRecord) ? :Guest : record.scope.to_s.capitalize
        h[scope] ||= []
        h[scope] << [record.label, record.scope_id]

        next unless selected_user.nil?
        next if record.is_a?(SwitchUser::GuestRecord)

        if provider.current_user?(record.user, record.scope)
          selected_user = record.scope_id
        end
      end
    end

    option_tags = grouped_options_for_select(grouped_options_container.to_a, selected_user)

    render partial: 'switch_user/widget',
           locals: {
             option_tags: option_tags,
             classes: options[:class],
             styles: options[:style],
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
