module Workflow
  module Lane
    module Write
      ReviewWeb = Trailblazer::Workflow::Collaboration.Lane(json: "app/concepts/workflow/blog.post-9.5.json", lane: "post.editor.review.ui.web", start_id: "Start.default") do
        {
          # "Review form" => [Subprocess(Post::Operation::Web::Review), output: {:post => :model, :model => :review, :contract => :contract}],
          "Review form" => Subprocess(Post::Operation::Web::Review),
          "SuggestChanges" => Subprocess(Review::Operation::Web::SuggestChanges),# output: {:post => :model, :model => :review, :contract => :contract}],
          "Approve" => Subprocess(Review::Operation::Web::Approve),# output: {:post => :model, :model => :review}],

          # "suggest_changes!" => [{task: Trailblazer::Workflow::Event::Throwing.new(semantic: "suggest_changes!")}, output: {:post => :model, :model => :review, :contract => :contract}],
          # "rejected?" => [{task: resume_rejected = Trailblazer::Workflow::Collaboration::Resume.new("rejected?").tap { |b| puts b.inspect }}, input: {:model => :post, :review => :model}],

          # "suspend-rejected?" => [{task: ->(*) { raise } }, {}]
        }
      end

      graph = Trailblazer::Activity::Introspect::Graph(ReviewWeb)
      suggest_changes = graph.find("suggest_changes!").task
      rejected = graph.find("rejected?").task
      approve = graph.find("approve!").task
      approved = graph.find("approved?").task

      # outgoing message
      suggest_changes_ext = Trailblazer::Activity::DSL::Linear.VariableMapping(output: {:post => :model, :model => :review, :contract => :contract})
      # incoming message
      rejected_ext        = Trailblazer::Activity::DSL::Linear.VariableMapping(input: {:model => :post, :review => :model}, output: ->(inner, original) { {model: inner[:model], post: inner[:post]} })

      bla = suggest_changes_ext.(config: ReviewWeb.to_h[:config], task: Struct.new(:circuit_task).new(suggest_changes))
      ReviewWeb[:wrap_static][suggest_changes] = bla[:wrap_static][suggest_changes]
      bla = rejected_ext.(config: ReviewWeb.to_h[:config], task: Struct.new(:circuit_task).new(rejected))
      ReviewWeb[:wrap_static][rejected] = bla[:wrap_static][rejected]

      bla = suggest_changes_ext.(config: ReviewWeb.to_h[:config], task: Struct.new(:circuit_task).new(approve))
      ReviewWeb[:wrap_static][approve] = bla[:wrap_static][approve]
      bla = rejected_ext.(config: ReviewWeb.to_h[:config], task: Struct.new(:circuit_task).new(approved))
      ReviewWeb[:wrap_static][approved] = bla[:wrap_static][approved]


      # raise ReviewWeb[:wrap_static][suggest_changes].inspect
    end
  end
end
