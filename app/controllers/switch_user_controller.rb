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
      provider.logout_all
    else
      params[:scope_identifier] =~ /^([^_]+)_(.*)$/
      scope, identifier = $1, $2

      user = SwitchUser::UserLoader.new(scope, identifier).load
      provider.login_exclusive(user, :scope => scope)
    end
  end

  def provider
    SwitchUser.provider_class.new(self)
  end
end
