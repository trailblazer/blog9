module Workflow
  module Lane
    PostLib = Trailblazer::Workflow::Collaboration.Lane(json: "../pro-backend/test/fixtures/blog.post.TRANSFORMED.json", lane: "post.lib", start_id: "catch-before-?Create!") do
      {
        "?Create!"          => Subprocess(Post::Operation::Create),
        "?Update!"          => Subprocess(Post::Operation::Update),
        "?Revise!"          => Subprocess(Post::Operation::Revise),
        "?Notify approver!" => Subprocess(Post::Operation::NotifyEditor),
        "?Delete!"          => Subprocess(Post::Operation::Delete),
        "?Reject!"          => [Subprocess(Post::Operation::Reject), input: {:model => :post, params: :params}, output: {:post => :model, :model => :review}],
        "?Approve!"         => Subprocess(Post::Operation::Approve),
        "?Archive!"         => Subprocess(Post::Operation::Archive),
        "?Publish!"         => Subprocess(Post::Operation::Publish),
      }
    end # PostLib
  end
end
