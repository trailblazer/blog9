module Post::Operation
  class Update < Trailblazer::Operation
    # class Present < Trailblazer::Operation
    #   step Model(Post, :find_by)
    #   step Contract::Build(constant: Post::Contract::Create)
    # end

    # step Nested(Present)
    # step Contract::Validate()
    # step Contract::Persist()
  end
end
