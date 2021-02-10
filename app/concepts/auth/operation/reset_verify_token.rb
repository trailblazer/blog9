module Auth::Operation
  class ResetVerifyToken < Trailblazer::Operation
    step :encrypted_verify_account_token
    step :save
    step :send_verify_account_email

    # def state(ctx, model:, **)
    #   model.state = "password set, please verify email"
    # end

    def save(ctx, model:, **)
      model.save
    end

    def encrypted_verify_account_token(ctx, model:, **)
      model.verify_account_token = "#{model.verify_account_token} 2"
    end

    def send_verify_account_email(ctx, model:, **)
      model.email # TODO
    end
  end
end
