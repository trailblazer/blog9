module Post::Operation::Web
  class New < Trailblazer::Operation # DISCUSS: reuse from Post:::Create?
    step Model(Post, :new)
    step Contract::Build(constant: Post::Operation::Create::Form) # we could be using our own Form here, adjusted for a web UI.
  end # New
end
