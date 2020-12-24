# DISCUSS: this is a lane, not a Collaboration!
module Workflow
  module Lane
    # json         = File.read("app/concepts/workflow/blog.post.01.json")
    json         = File.read("../pro-backend/test/fixtures/blog.post.TRANSFORMED.json")
    intermediate = Trailblazer::Workflow::Generate::Collaboration.Lane("post.lib", JSON[json], start_id: "catch-before-?Create!")

    activity = Trailblazer::Activity::Railway

    PostLib = Trailblazer::Workflow::Collaboration.implement(
      intermediate,
      {
        "?Create!" => activity.Subprocess(Post::Operation::Create),
        "?Update!" => activity.Subprocess(Post::Operation::Update),
        "?Notify approver!" => activity.Subprocess(Post::Operation::NotifyEditor),
        "?Delete!" => activity.Subprocess(Post::Operation::Delete),
        "?Reject!" => activity.Subprocess(Post::Operation::Reject),
        "?Approve!" => activity.Subprocess(Post::Operation::Approve),
        "?Archive!" => activity.Subprocess(Post::Operation::Archive),
        "?Publish!" => activity.Subprocess(Post::Operation::Publish),
      }
    )
  end
end
