require "test_helper"

class PostCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Testing::AssertPosition

  let(:moment) { Trailblazer::Workflow::Moment::DSL }

  # TODO: abstract to endpoint/test
  def ctx_for(event_name, params: {}, process_model: nil, activity: Workflow::Collaboration::WriteWeb)
    domain_ctx = {params: params}

    ctx = {activity: activity, event_name: event_name, process_model: process_model, domain_ctx: domain_ctx} # TODO: require domain_ctx if scoping on.
  end

  # TODO: abstract to endpoint/test
  def args_for(*args)
    [ctx_for(*args), {context_options: {}, throw: []}]
  end

  # TODO: abstract to endpoint/test
  # DISCUSS: this assumes that we have an Endpoint/Advance ctx here.
  def assert_position(ctx, *args, collaboration: Workflow::Collaboration::WriteWeb)
    super(ctx[:returned][0].to_h, *args, collaboration: collaboration)
  end

  it "what" do
    endpoint = Trailblazer::Workflow.Advance(activity: Workflow::Collaboration::WriteWeb)


  # invalid Create data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?"))

    assert_position ctx, moment.before("catch-before-?Create!"), moment.before("new?")

  # processable Create data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, args_for("web:new?", params: {post: {content: "That was great!"}}))

    assert_position ctx, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form?", "request_approval?")
  end
end
