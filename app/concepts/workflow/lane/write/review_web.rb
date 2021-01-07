module Workflow
  module Lane
    module Write
      ReviewWeb = Trailblazer::Workflow::Collaboration.Lane(json: "../pro-backend/test/fixtures/blog.post.TRANSFORMED.json", lane: "post.editor.review.ui.web", start_id: "Start.default") do
        {}
      end
    end
  end
end
