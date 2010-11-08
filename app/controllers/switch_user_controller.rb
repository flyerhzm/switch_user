class SwitchUserController < ApplicationController

  before_filter :developer_modes_only

  def set_current_user
    if params[:scope_id].blank?
      SwitchUser.available_users.keys.each do |s|
        warden.logout(s)
      end
    else
      scope, id = params[:scope_id].split('_')
      SwitchUser.available_users.keys.each do |s|
        if scope == s.to_s
          user = scope.classify.constantize.find(id)
          warden.set_user(user, :scope => scope)
        else
          warden.logout(s)
        end
      end
    end
    redirect_to(request.env["HTTP_REFERER"] ? :back : root_path)
  end

  private

  def developer_modes_only
    render :text => "Permission Denied", :status => 403 unless Rails.env == "development"
  end
end
