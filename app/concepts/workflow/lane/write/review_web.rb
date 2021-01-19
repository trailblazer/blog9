module Workflow
  module Lane
    module Write
      ReviewWeb = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/workflow/blog.post-9.4.json", lane: "post.editor.review.ui.web", start_id: "Start.default") do
        {}
      end
    end
  end
end
