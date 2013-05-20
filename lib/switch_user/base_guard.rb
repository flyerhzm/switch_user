module SwitchUser
  class BaseGuard
    # TODO is this the best arguments for the initializer ?
    # TODO should @provider be set and current/original_user be added as # accessors ?
    def initialize(controller, provider)
      @controller    = controller
      @request       = controller.request
      @current_user  = provider.current_user
      @original_user = provider.original_user
    end

    def controller_available?
      raise NotImplementedError.new("you must implement controller_available?")
    end

    def view_available?
      controller_available?
    end
  end
end
