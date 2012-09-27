class SwitchUserController < ApplicationController

  unless Rails.version =~ /^3/
    unloadable
  end

  before_filter :developer_modes_only

  def set_current_user
    handle_request(params)

    redirect_to(SwitchUser.redirect_path.call(request, params))
  end

  private

  def developer_modes_only
    render :text => "Permission Denied", :status => 403 unless available?
  end

  def available?
    SwitchUser.controller_guard.call(provider.current_user, request)
  end

  def handle_request(params)
    if params[:scope_identifier].blank?
      SwitchUser.available_users.keys.each do |s|
        provider.logout(s)
      end
    else
      params[:scope_identifier] =~ /^([^_]+)_(.*)$/
      scope, identifier = $1, $2

      SwitchUser.available_users.keys.each do |s|
        if scope == s.to_s
          user = find_user(scope, s, identifier)
          provider.login(user, scope)
        else
          provider.logout(s)
        end
      end
    end
  end

  def find_user(scope, identifier_scope, identifier)
    identifier_column = SwitchUser.available_users_identifiers[identifier_scope] || :id
    if identifier_column == :id
      scope.classify.constantize.find(identifier)
    else
      scope.classify.constantize.send("find_by_#{identifier_column}!", identifier)
    end
  end

  def provider
    provider_class.new(self)
  end

  def provider_class
    "SwitchUser::Provider::#{SwitchUser.provider.to_s.classify}".constantize
  end
end
