module SwitchUser
  class LambdaGuard < BaseGuard
    def controller_available?
      call(SwitchUser.controller_guard)
    end

    def view_available?
      call(SwitchUser.view_guard)
    end

    private

    def args
      [@current_user, @request, @original_user, @controller]
    end

    def call(guard)
      arity = guard.arity
      guard.call(*args[0...arity])
    end
  end
end
