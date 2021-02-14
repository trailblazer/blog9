module Auth::Operation
  class ResetPassword < Trailblazer::Operation
    pass :reset_password
    step :encrypted_verify_account_token
    step :state
    step :save

    # def state(ctx, model:, **)
    #   model.state = "password set, please verify email"
    # end

    def save(ctx, model:, **)
      model.save
    end

    def encrypted_verify_account_token(ctx, model:, **)
      model.verify_account_token = "more random".reverse
    end

    def state(ctx, model:, **)
      model.state = "password reset, please change password"
    end

    def save(ctx, model:, **)
      model.save
    end

    def reset_password(ctx, model:, **)
      model.password = nil
    end

  end
end
