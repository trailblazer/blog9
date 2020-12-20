require "test_helper"

class PostCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Testing::AssertPosition

  let(:moment) { Trailblazer::Workflow::Moment::DSL }

  it "what" do
    endpoint = Trailblazer::Workflow.Advance(activity: Workflow::Collaboration::WriteWeb)

    domain_ctx = {params: {}}
    ctx = {activity: Workflow::Collaboration::WriteWeb, event_name: "web:new?", process_model: nil, domain_ctx: domain_ctx} # TODO: require domain_ctx if scoping on.

  # invalid Create data
    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, [ctx, {context_options: {}, throw: []}])

    assert_position ctx[:returned][0].to_h, moment.before("catch-before-?Create!"), moment.before("new?"), collaboration: Workflow::Collaboration::WriteWeb


  # processable Create data
    domain_ctx = {params: {post: {content: "That was great!"}}}
    ctx = {activity: Workflow::Collaboration::WriteWeb, event_name: "web:new?", process_model: nil, domain_ctx: domain_ctx}

    signal, (ctx, _) = Trailblazer::Developer.wtf?(endpoint, [ctx, {context_options: {}, throw: []}])

    assert_position ctx[:returned][0].to_h, moment.before("catch-before-?Update!", "catch-before-?Notify approver!"), moment.before("edit_form?", "request_approval?"), collaboration: Workflow::Collaboration::WriteWeb
  end
end
