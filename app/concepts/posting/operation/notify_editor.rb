module Posting::Operation
  class NotifyEditor < Trailblazer::Operation
    step :start_review
    step :state
    # step Contract::Persist()

    def start_review(ctx, model:, **)
      ctx[:review] = Review.create(posting_id: model.id
        # , state: "waiting for editor"
        )
    end

    def state(ctx, model:, **)
      model.state = "waiting for review"
      model.save
    end
  end
end
