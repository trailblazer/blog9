module Workflow
  module Lane
    # Expects {:process_model} to be a {Post}.
    PostLib = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/workflow/blog.post-9.5.json", lane: "post.lib", start_id: "catch-before-?Create!") do
      {
        "?Create!"          => Subprocess(Post::Operation::Create),
        "?Update!"          => Subprocess(Post::Operation::Update),
        "?Revise!"          => Subprocess(Post::Operation::Revise),
        "?Notify approver!" => Subprocess(Post::Operation::NotifyEditor),
        "?Delete!"          => Subprocess(Post::Operation::Delete),
        "?Reject!"          => Subprocess(Post::Operation::Reject),
        "?Approve!"         => Subprocess(Post::Operation::Approve),
        "?Archive!"         => Subprocess(Post::Operation::Archive),
        "?Publish!"         => Subprocess(Post::Operation::Publish),
      }
    end # PostLib
  end
end
