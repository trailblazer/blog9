module Post::Operation
  class NotifyEditor < Trailblazer::Operation
    step :send_notification
    step :state
    # step Contract::Persist()

    def send_notification(ctx, model:, **)
      true
    end

    def state(ctx, model:, **)
      model.state = "waiting for approval"
      model.save
    end
  end
end
