module Provider
  class Devise
    def initialize(controller)
      @controller = controller
      @warden = @controller.warden
    end

    def login(user, scope = nil)
      @warden.set_user(user, :scope => scope)
    end

    def logout(scope = nil)
      @warden.logout(scope)
    end

    def current_user(scope = nil)
      @controller.current_user
    end
  end
end
