class SwitchUserController < ApplicationController
  before_filter :developer_modes_only

  def set_current_user
    handle_request(params)

    redirect_to(SwitchUser.redirect_path.call(request, params))
  end

  def remember_user
    # NOOP unless the user has explicity enabled this feature
    if SwitchUser.switch_back
      provider.remember_current_user(params[:remember] == "true")
    end

    redirect_to(SwitchUser.redirect_path.call(request, params))
  end

  private

  def developer_modes_only
    render :text => "Permission Denied", :status => 403 unless available?
  end

  def available?
    SwitchUser.controller_guard(provider.current_user,
                                request,
                                provider.original_user)
  end

  def handle_request(params)
    if params[:scope_identifier].blank?
      provider.logout_all
    else
      loader = SwitchUser::UserLoader.prepare(params)
      if SwitchUser.login_exclusive
        provider.login_exclusive(loader.user, :scope => loader.scope)
      else
        provider.login_inclusive(loader.user, :scope => loader.scope)
      end
    end
  end

  def provider
    SwitchUser::Provider.init(self)
  end
end
