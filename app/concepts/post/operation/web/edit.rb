module Post::Operation::Web
  class Edit < Trailblazer::Operation # DISCUSS: reuse from Post:::Create?
    # step Model(Post, :new)
    step Contract::Build(constant: Post::Operation::Create::Form) # we could be using our own Form here, adjusted for a web UI.
  end # Edit
end
