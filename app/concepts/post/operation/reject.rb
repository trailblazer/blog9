module Post::Operation
  class Reject < Trailblazer::Operation
    class Form < Reform::Form
      property :suggestions
      property :state, parse: false
      property :post_id, parse: false

      validates :suggestions, presence: true
    end

    # class Present < Trailblazer::Operation
    step Model(Review)
    step Contract::Build(constant: Form)
    # end

    # step Nested(Present)

    step Contract::Validate(key: :review)
    step :state
    step :associate_post
    step Contract::Persist()

    def state(ctx, contract:, **)
      contract.state = "edit requested"
    end

    def associate_post(ctx, post:, contract:, **)
      contract.post_id = post.id
    end
  end
end
