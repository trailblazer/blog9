module Posting::Operation
  class Publish < Trailblazer::Operation
    step :slug
    step :state
    step :save # TODO: replace with Persist().

    def slug(ctx, model:, controller:, **)
      model.slug = slug_for(model, controller)
    end

    def state(ctx, model:, **)
      model.state = "published"
      model.save
    end

    def save(ctx, model:, **)
      model.save
    end

  private
    def slug_for(post, controller)
      filename = post.content[0..18].gsub(/[^\w]/, "-").downcase
      # controller.post_slug_path(filename: filename) # use Rails URL helper
      "fixme"
    end

  end
end
