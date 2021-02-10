module Auth::Operation
  class VerifyAccount < Trailblazer::Operation
    # DISCUSS: we find the process_model outside in another lane, or in the endpoint?

    pass :expire_verify_account_token
    step :state
    step :save

    def state(ctx, model:, **)
      model.state = "ready to signin"
    end

    def save(ctx, model:, **)
      model.save
    end

    def expire_verify_account_token(ctx, model:, **)
      model.verify_account_token = nil
    end
  end
end
