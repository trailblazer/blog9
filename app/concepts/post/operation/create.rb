module Post::Operation
  class Create < Trailblazer::Operation
    class Form < Reform::Form
      property :content
      property :state, parse: false

      validates :content, presence: true
    end

    # class Present < Trailblazer::Operation
      step Model(Post, :new)
      step Contract::Build(constant: Form)
    # end

    # step Nested(Present)

    step Contract::Validate(key: :post)
    step :state
    step Contract::Persist()

    def state(ctx, contract:, **)
      contract.state = "created"
    end
  end
end
