module Provider
  class Sorcery
    def initialize(controller)
      @controller = controller
    end

    def login(user)
      @controller.auto_login(user)
    end

    def logout
      @controller.logout
    end

    def current_user
      @controller.current_user
    end
  end
end
