module Post::Operation
  class Reject < Trailblazer::Operation
    class Form < Reform::Form
      property :suggestions
      # property :state, parse: false
      property :post_id, parse: false

      validates :suggestions, presence: true
    end

    # class Present < Trailblazer::Operation
    # step Model(Review)
    step :model
    step Contract::Build(constant: Form)
    # end

    # step Nested(Present)

    step Contract::Validate(key: :review)
    step :post_state
    # step :review_state
    step :associate_post
    step Contract::Persist()

    def model(ctx, post:, **)
      ctx[:model] = post.reviews[0] # FIXME: should we work based on the review-id here?
    end

    def post_state(ctx, post:, **)
      post.state = "edit requested"
      post.save
    end

    # def review_state(ctx, contract:, **)
    #   contract.state = "waiting for edit" # DISCUSS: do we need this?
    # end

    def associate_post(ctx, post:, contract:, **)
      contract.post_id = post.id
    end
  end
end
