module Post::Operation
  class Publish < Trailblazer::Operation
    step :state

    def state(ctx, model:, **)
      model.state = "published"
      model.save
    end
  end
end
