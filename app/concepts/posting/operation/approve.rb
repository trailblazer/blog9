module Posting::Operation
  class Approve < Trailblazer::Operation # @requires {:model}, {:review}
    step :state

    def state(ctx, model:, **)
      model.state = "approved, ready to publish"
      model.save
    end
  end
end
