module Workflow
  module Lane
    module Write
      ReviewWeb = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/workflow/blog.post-9.5.json", lane: "post.editor.review.ui.web", start_id: "Start.default") do
        {
          "Review form" => [Subprocess(Post::Operation::Web::Review), output: {:post => :model, :model => :review, :contract => :contract}],
          "SuggestChanges" => [Subprocess(Review::Operation::Web::SuggestChanges), output: {:post => :model, :model => :review, :contract => :contract}],
          "Approve" => [Subprocess(Review::Operation::Web::Approve), output: {:post => :model, :model => :review}],
        }
      end
    end
  end
end
