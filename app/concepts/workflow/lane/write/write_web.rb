module Workflow
  module Lane
    module Write
      WriteWeb = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/workflow/blog.post-9.3.json", lane: "post.writer.ui.web", start_id: "new_form?") do
        {} # we don't have any tasks, we only send events. The rendering is done in the controller.
      end # WriteWeb
    end
  end
end
