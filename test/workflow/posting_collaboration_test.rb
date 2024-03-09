=begin
+--------------------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| triggered catch    | start configuration                                                                                                   | expected reached configuration                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
| ☝ ⏵︎Create form     | ⛾ ⏵︎Create                  ☝ ⏵︎Create form                                                          ☑ ⏵︎Notify          | ⛾ ⏵︎Create                  ☝ ⏵︎Create                                                               ☑ ⏵︎Notify          |
| ☝ ⏵︎Create          | ⛾ ⏵︎Create                  ☝ ⏵︎Create                                                               ☑ ⏵︎Notify          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                                         ☑ ⏵︎Notify          |
| ☝ ⏵︎Update form     | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                                         ☑ ⏵︎Notify          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update                                                               ☑ ⏵︎Notify          |
| ☝ ⏵︎Notify approver | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                                         ☑ ⏵︎Notify          | ⛾ ⏵︎Reject ⏵︎Approve         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 ☑ ⏵︎Approve ⏵︎Reject |
| ☝ ⏵︎Update          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update                                                               ☑ ⏵︎Notify          | ⛾ ⏵︎Notify approver ⏵︎Update ☝ ⏵︎Update form ⏵︎Notify approver                                         ☑ ⏵︎Notify          |
| ☑ ⏵︎Approve         | ⛾ ⏵︎Reject ⏵︎Approve         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 ☑ ⏵︎Approve ⏵︎Reject | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                                   ☑ ◉End.:success    |
| ☑ ⏵︎Reject          | ⛾ ⏵︎Reject ⏵︎Approve         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 ☑ ⏵︎Approve ⏵︎Reject | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise form                                                          ☑ ◉End.:success    |
| ☝ ⏵︎Delete? form    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                                   ☑ ◉End.:success    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Delete ⏵︎Cancel                                                       ☑ ◉End.:success    |
| ☝ ⏵︎Publish         | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                                   ☑ ◉End.:success    | ⛾ ⏵︎Archive                 ☝ ⏵︎Archive                                                              ☑ ◉End.:success    |
| ☝ ⏵︎Revise form     | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise form                                                          ☑ ◉End.:success    | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise                                                               ☑ ◉End.:success    |
| ☝ ⏵︎Delete          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Delete ⏵︎Cancel                                                       ☑ ◉End.:success    | ⛾ ◉End.success             ☝ ◉End.success                                                          ☑ ◉End.:success    |
| ☝ ⏵︎Cancel          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Delete ⏵︎Cancel                                                       ☑ ◉End.:success    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                                   ☑ ◉End.:success    |
| ☝ ⏵︎Archive         | ⛾ ⏵︎Archive                 ☝ ⏵︎Archive                                                              ☑ ◉End.:success    | ⛾ ◉End.success             ☝ ◉End.success                                                          ☑ ◉End.:success    |
| ☝ ⏵︎Revise          | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise                                                               ☑ ◉End.:success    | ⛾ ⏵︎Revise ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                                         ☑ ◉End.:success    |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+
=end

require "test_helper"

class Posting_CollaborationCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Test::Assertions
  require "trailblazer/test/assertions"
  include Trailblazer::Test::Assertions # DISCUSS: this is for assert_advance and friends.


  it "can run the collaboration" do
    schema = Posting::Collaboration
    # TODO: do this in an initializer?
    test_plan = Trailblazer::Workflow::Introspect::Iteration::Set::Deserialize.(JSON.parse(File.read("app/concepts/posting/posting-v1-discovered-iterations.json")), lanes_cfg: schema.to_h[:lanes])


    # DISCUSS: here, we technically should go through all possible paths. This is, to a certain degree, possible with discovery automation.
    # DISCUSS: also, we could automatically test not allowed transitions.

    # test: ☝ ⏵︎Create form
    ctx = assert_advance "☝ ⏵︎Create form", test_plan: test_plan, schema: schema
    # assert_exposes ctx, seq: [:revise, :revise], reader: :[]
    assert_equal ctx[:"contract.default"].class, Post::Operation::Create::Form
    assert_equal ctx[:"contract.default"].content, nil


    # test: ☝ ⏵︎Create
    ctx = assert_advance "☝ ⏵︎Create", test_plan: test_plan, schema: schema, ctx: {params: {post: {content: "Exciting times!"}}}, flow_options: Blog9::FLOW_OPTIONS
    assert_equal ctx[:contract].class, Post::Operation::Create::Form
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "created"

    original_model = ctx[:model]

    # test: ☝ ⏵︎Notify approver
    ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "waiting for review"


    # test: ☑ ⏵︎Approve
    ctx = assert_advance "☑ ⏵︎Approve", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "approved, ready to publish"


    # test: ☝ ⏵︎Publish
    ctx = assert_advance "☝ ⏵︎Publish", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model], controller: Rails.application.routes.url_helpers}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "published"


    # test: ☝ ⏵︎Archive
    ctx = assert_advance "☝ ⏵︎Archive", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "archived"


# test: ☝ ⏵︎Update form
ctx = assert_advance "☝ ⏵︎Update form", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id}}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].class, Post::Operation::Create::Form
assert_equal ctx[:contract].content, "Exciting times!"

# test: ☝ ⏵︎Update
ctx = assert_advance "☝ ⏵︎Update", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id, post: {content: "Exciting day"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: "updated"
  assert_equal original_model.id, ctx[:model].id

# test: ☝ ⏵︎Notify approver
ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: "waiting for review"


# test: ☑ ⏵︎Reject
ctx = assert_advance "☑ ⏵︎Reject", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model], review: Review.new(suggestions: "you can do better!", post_id: ctx[:model].id)}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: "edit requested"
assert_equal ctx[:model].review.post, ctx[:model]

# test: ☝ ⏵︎Revise form
ctx = assert_advance "☝ ⏵︎Revise form", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id}}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].content, "Exciting day"
# TODO: also test review suggestions.

# test: ☝ ⏵︎Revise
ctx = assert_advance "☝ ⏵︎Revise", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id, post: {content: "Truly epic"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "revised, review requested", id: original_model.id # FIXME: state label is confusing

# TODO: test another revision of the author

# test: ☝ ⏵︎Notify approver
ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "waiting for review"

# test: ☑ ⏵︎Approve
ctx = assert_advance "☑ ⏵︎Approve", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "approved, ready to publish"

# test: ☝ ⏵︎Delete? form
ctx = assert_advance "☝ ⏵︎Delete? form", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id, post: {content: "Truly epic"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].class, Post::Operation::Create::Form



# test: ☝ ⏵︎Delete
ctx = assert_advance "☝ ⏵︎Delete", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id, post: {content: "Truly epic"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx, seq: [:revise, :revise], reader: :[]


# test: ☝ ⏵︎Cancel
ctx = assert_advance "☝ ⏵︎Cancel", test_plan: test_plan, schema: schema, ctx: {params: {id: ctx[:model].id, post: {content: "Truly epic"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx, seq: [:revise, :revise], reader: :[]



  end
end
