module Workflow
  module Lane
    module Write
      WriteWeb = Trailblazer::Workflow::Collaboration.Lane(json: "../pro-backend/test/fixtures/blog.post.TRANSFORMED.json", lane: "post.writer.ui.web", start_id: "new?!") do
        {} # we don't have any tasks, we only send events. The rendering is done in the controller.
      end # WriteWeb
    end
  end
end
