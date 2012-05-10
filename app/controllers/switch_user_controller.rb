class SwitchUserController < ApplicationController

  unless Rails.version =~ /^3/
    unloadable
  end

  before_filter :developer_modes_only

  def set_current_user
    send("#{SwitchUser.provider}_handle", params)
    redirect_to(SwitchUser.redirect_path.call(request, params))
  end

  def set_original_user
    send("#{SwitchUser.provider}_reset", params)
    redirect_to(SwitchUser.redirect_path.call(request, params))
  end

  private
    def developer_modes_only
      render :text => "Permission Denied", :status => 403 unless available?
    end

    def available?
      current_user = send("#{SwitchUser.provider}_current_user")
      SwitchUser.controller_guard.call(current_user, request)
    end

    def devise_handle(params)
      if params[:scope_identifier].blank?
        SwitchUser.available_users.keys.each do |s|
          warden.logout(s)
        end
      else
        params[:scope_identifier] =~ /^([^_]+)_(.*)$/
        scope, identifier = $1, $2

        SwitchUser.available_users.keys.each do |s|
          if scope == s.to_s
            original_user_id, original_user_scope = nil, nil
            if current_user
              original_user_id    = user_session[:original_user_id]
              original_user_scope = user_session[:original_user_scope]
              original_user_id    = current_user.id if    original_user_id.blank?
              original_user_scope = scope           if original_user_scope.blank?
            end
            user = find_user(scope, s, identifier)
            warden.set_user(user, :scope => scope)
            if current_user
              user_session[:original_user_id]    = original_user_id
              user_session[:original_user_scope] = original_user_scope
            end
          else
            warden.logout(s)
          end
        end
      end
    end

    def devise_reset(params)
      if params[:scope_identifier].blank?
        SwitchUser.available_users.keys.each do |s|
          warden.logout(s)
        end
      else
        params[:scope_identifier] =~ /^([^_]+)_(.*)$/
        scope, identifier = $1, $2
        original_user_id, original_user_scope = nil, nil
        if current_user
          original_user_id    = user_session[:original_user_id]
          original_user_scope = user_session[:original_user_scope]
        end
        user_session[:original_user_id]    = nil
        user_session[:original_user_scope] = nil
        user = find_user(original_user_scope, original_user_scope, original_user_id)
        warden.set_user(user, :scope => original_user_scope)

      end
    end

    def authlogic_handle(params)
      if params[:scope_identifier].blank?
        current_user_session.destroy
      else
        params[:scope_identifier] =~ /^([^_]+)_(.*)$/
        scope, identifier = $1, $2

        SwitchUser.available_users.keys.each do |s|
          if scope == s.to_s
            user = find_user(scope, s, identifier)
            UserSession.create(user)
          end
        end
      end
    end

    def restful_authentication_handle(params)
      if params[:scope_identifier].blank?
        logout_killing_session!
      else
        params[:scope_identifier] =~ /^([^_]+)_(.*)$/
        scope, identifier = $1, $2

        SwitchUser.available_users.keys.each do |s|
          if scope == s.to_s && user = find_user(scope, s, identifier)
            self.current_user = user
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

    def devise_current_user
      current_user
    end

    def authlogic_current_user
      UserSession.find.try(:record)
    end

    def restful_authentication_current_user
      current_user
    end
end
