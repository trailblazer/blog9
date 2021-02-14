module Auth::Operation
  class UpdatePassword < Trailblazer::Operation
    # FIXME: use this in Signup

    # TODO: who checks verify token?

    step :encrypted_password
    pass :expire_verify_account_token
    step :state
    step :save

    def state(ctx, model:, **)
      model.state = "password updated, ready to signin"
    end

    def encrypted_password(ctx, model:, password:, **)
      model.password = password.reverse # TODO: use real encryption/Tyrant/Rodauth
    end

    def expire_verify_account_token(ctx, model:, **)
      model.verify_account_token = nil
    end

    def save(ctx, model:, **)
      model.save
    end
  end
end
