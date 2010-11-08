class SwitchUserController < ApplicationController

  before_filter :developer_modes_only

  def set_current_user
    if params[:user_id].blank?
      warden.logout(:user)
    else
      current_user = User.find(params[:user_id])
      warden.set_user(current_user, :scope => :user)
    end
    redirect_to(request.env["HTTP_REFERER"] ? :back : root_path)
  end

  private

  def developer_modes_only
    render :text => "Permission Denied", :status => 403 unless Rails.env == "development"
  end
end
