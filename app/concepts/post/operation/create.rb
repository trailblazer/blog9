module Post::Operation
  class Create < Trailblazer::Operation
    # class Present < Trailblazer::Operation
    #   step Model(Post, :new)
    #   step Contract::Build(constant: Post::Contract::Create)
    # end

    # step Nested(Present)
    # step Contract::Validate()
    # step Contract::Persist()
  end
end
