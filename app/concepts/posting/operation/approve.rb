module Posting::Operation
  class Approve < Trailblazer::Operation # @requires {:model}, {:review}
    step :state

    def state(ctx, model:, **)
      # model.state = "approved, ready to publish"
      model.state = "⏸︎ Update form♦Delete? form♦Publish [110]"
      model.save
    end
  end
end
