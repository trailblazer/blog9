module Workflow
  module Lane
    module Write
      WriteWeb = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/workflow/blog.post-9.4.json", lane: "post.writer.ui.web", start_id: "new_form?") do
        {
          "New form" => Subprocess(Post::Operation::Web::New),
          "Edit form" => Subprocess(Post::Operation::Web::Edit),
          "Revise form" => Subprocess(Post::Operation::Web::Revise),
        } # we have a few tasks, only, mostly we send events. The rendering is done in the controller.
      end # WriteWeb
    end
  end
end
