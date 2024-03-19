module Posting::Operation
  class Update < Trailblazer::Operation # DISCUSS: inherit from {Create}?
    class Present < Trailblazer::Operation
      # step Model(Post, :find_by)
      step Contract::Build(constant: Posting::Operation::Create::Form)
    end

    step Nested(Present)
    step Contract::Validate(key: :post)
    step :state
    step Contract::Persist()

    def state(ctx, contract:, **)
      contract.state = "updated"
    end
  end
end
