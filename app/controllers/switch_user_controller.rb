class SwitchUserController < ApplicationController

  unless Rails.version =~ /^3/
    unloadable
  end

  before_filter :developer_modes_only

  def set_current_user
    send("#{SwitchUser.provider}_handle", params)
    redirect_to(SwitchUser.redirect_path.call(request, params))
  end

  private
    def developer_modes_only
      render :text => "Permission Denied", :status => 403 unless available?
    end

    def available?
      user = nil
      current_user = send("#{SwitchUser.provider}_current_user")
      if params[:scope_id].present?
        params[:scope_id] =~ /^([^_]+)_(.*)$/
        scope, id = $1, $2
        SwitchUser.available_users.keys.each do |s|
          if scope == s.to_s
            finder = SwitchUser.available_users_identifiers[s] || "id"
            user = scope.classify.constantize.send("find_by_#{finder}!", id)
            break
          end
        end
      end
      SwitchUser.controller_guard.call(current_user, request)
    end

    def devise_handle(params)
      if params[:scope_id].blank?
        SwitchUser.available_users.keys.each do |s|
          warden.logout(s)
        end
      else
        params[:scope_id] =~ /^([^_]+)_(.*)$/
        scope, id = $1, $2

        SwitchUser.available_users.keys.each do |s|
          if scope == s.to_s
            finder = SwitchUser.available_users_identifiers[s] || "id"
            user = scope.classify.constantize.send("find_by_#{finder}!", id)
            warden.set_user(user, :scope => scope)
          else
            warden.logout(s)
          end
        end
      end
    end

    def authlogic_handle(params)
      if params[:scope_id].blank?
        current_user_session.destroy
      else
        params[:scope_id] =~ /^([^_]+)_(.*)$/
        scope, id = $1, $2

        SwitchUser.available_users.keys.each do |s|
          if scope == s.to_s
            finder = SwitchUser.available_users_identifiers[s] || "id"
            user = scope.classify.constantize.send("find_by_#{finder}!", id)
            UserSession.create(user)
          end
        end
      end
    end

    def devise_current_user
      current_user
    end

    def authlogic_current_user
      UserSession.find.record
    end
end
