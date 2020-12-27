module Post::Operation
  class Approve < Trailblazer::Operation
    step :state

    def state(ctx, model:, **)
      model.state = "approved"
      model.save
    end
  end
end
