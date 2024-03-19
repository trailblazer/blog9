module Posting::Operation
  class Archive < Trailblazer::Operation
    step :state

    def state(ctx, model:, **)
      model.state = "archived"
      model.save
    end

  end
end
