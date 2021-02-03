module Post::Operation
  class Reject < Trailblazer::Operation # @requires {:model}, {:review}
    # class Form < Reform::Form
    #   property :suggestions
    #   # property :state, parse: false
    #   property :post_id, parse: false

    #   validates :suggestions, presence: true
    # end

    # DISCUSS: basic validation?

    step :post_state
    step :persist

    def post_state(ctx, model:, **)
      model.state = "edit requested"
    end

    # def review_state(ctx, contract:, **)
    #   contract.state = "waiting for edit" # DISCUSS: do we need this?
    # end

    def persist(ctx, model:, review:, **)
      model.save
      review.save
    end
  end
end
