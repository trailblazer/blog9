module Post::Operation
  class Delete < Trailblazer::Operation
    # step Model(Post, :find_by)
    step :delete!

    def delete!(options, model:, **)
      model.destroy
    end
  end
end
