# DISCUSS: this is a lane, not a Collaboration!
module Workflow
  module Lane
    module Write
      # json         = File.read("app/concepts/workflow/blog.post.01.json")
      json         = File.read("../pro-backend/test/fixtures/blog.post.TRANSFORMED.json")
      intermediate, messages = Trailblazer::Workflow::Generate::Collaboration.Lane("post.editor.review.ui.web", JSON[json], start_id: "Start.default")

      activity = Trailblazer::Activity::Railway

      ReviewWeb = Trailblazer::Workflow::Collaboration.implement(
        intermediate,
        {
          # "Create" => activity.Subprocess(Post::Operation::Create),
          # "?Update!" => activity.Subprocess(Post::Operation::Update),
          # "?Notify approver!" => activity.Subprocess(Post::Operation::NotifyEditor),
          # "?Delete!" => activity.Subprocess(Post::Operation::Delete),
          # "?Reject!" => activity.Subprocess(Post::Operation::Reject),
          # "?Approve!" => activity.Subprocess(Post::Operation::Approve),
          # "?Archive!" => activity.Subprocess(Post::Operation::Archive),
          # "?Publish!" => activity.Subprocess(Post::Operation::Publish),
        },
        config_merge: {lane_name: "post.editor.review.ui.web", messages: messages}
      )
    end
  end
end
