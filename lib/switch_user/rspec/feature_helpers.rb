# frozen_string_literal: true

module SwitchUser
  module RSpecFeatureHelpers
    class InvalidArgument < StandardError; end

    def switch_user(user_record_or_scope, user_id = nil)
      _user_scope =
        case user_record_or_scope
        when ActiveRecord::Base
          user_record_or_scope.model_name.singular
        else
          user_record_or_scope
        end

      _user_scope = _user_scope.to_s

      unless SwitchUser.available_scopes.include?(_user_scope) || SwitchUser.available_scopes.include?(_user_scope.to_sym)
        raise SwitchUser::InvalidScope, "don't allow this user sign in, please check config.available_users"
      end

      _user_id =
        case user_record_or_scope
        when ActiveRecord::Base
          identifier = SwitchUser.available_users_identifiers[_user_scope] || SwitchUser.available_users_identifiers[_user_scope.to_sym]
          if identifier.nil?
            raise SwitchUser::InvalidScope, "don't allow switch this user, please check config.available_users_identifiers"
          end
          user_record_or_scope.send identifier
        else
          user_id
        end

      if _user_id.to_s.empty?
        raise InvalidArgument, "don't allow switch this user, user_id is empty"
      end

      scope_identifier = "#{_user_scope}_#{_user_id}"

      visit "/switch_user?scope_identifier=#{scope_identifier}"
    end
  end
end
