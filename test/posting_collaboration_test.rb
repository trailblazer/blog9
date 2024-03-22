=begin
  +--------------------+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------+
| triggered catch    | start configuration                                                                                     | expected reached configuration                                                                          |
+--------------------+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------+
| ☝ ⏵︎Create form     | ⛾ ⏵︎Create                  ☝ ⏵︎Create form                                            ☑ ⏵︎Notify          | ⛾ ⏵︎Create                  ☝ ⏵︎Create                                                 ☑ ⏵︎Notify          |
| ☝ ⏵︎Create          | ⛾ ⏵︎Create                  ☝ ⏵︎Create                                                 ☑ ⏵︎Notify          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                           ☑ ⏵︎Notify          |
| ☝ ⏵︎Create ⛞        | ⛾ ⏵︎Create                  ☝ ⏵︎Create                                                 ☑ ⏵︎Notify          | ⛾ ⏵︎Create                  ☝ ⏵︎Create                                                 ☑ ⏵︎Notify          |
| ☝ ⏵︎Update form     | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                           ☑ ⏵︎Notify          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update                                                 ☑ ⏵︎Notify          |
| ☝ ⏵︎Notify approver | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update form ⏵︎Notify approver                           ☑ ⏵︎Notify          | ⛾ ⏵︎Reject ⏵︎Approve         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎catch-before-Activity_0zsock2 ☑ ⏵︎Approve ⏵︎Reject |
| ☝ ⏵︎Update          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update                                                 ☑ ⏵︎Notify          | ⛾ ⏵︎Notify approver ⏵︎Update ☝ ⏵︎Update form ⏵︎Notify approver                           ☑ ⏵︎Notify          |
| ☑ ⏵︎Approve         | ⛾ ⏵︎Reject ⏵︎Approve         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎catch-before-Activity_0zsock2 ☑ ⏵︎Approve ⏵︎Reject | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                     ☑ ◉End.:success    |
| ☑ ⏵︎Reject          | ⛾ ⏵︎Reject ⏵︎Approve         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎catch-before-Activity_0zsock2 ☑ ⏵︎Approve ⏵︎Reject | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise                                                 ☑ ◉End.:success    |
| ☝ ⏵︎Update ⛞        | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update                                                 ☑ ⏵︎Notify          | ⛾ ⏵︎Update ⏵︎Notify approver ☝ ⏵︎Update                                                 ☑ ⏵︎Notify          |
| ☝ ⏵︎Delete? form    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                     ☑ ◉End.:success    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Delete ⏵︎Cancel                                         ☑ ◉End.:success    |
| ☝ ⏵︎Publish         | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                     ☑ ◉End.:success    | ⛾ ⏵︎Archive                 ☝ ⏵︎Archive                                                ☑ ◉End.:success    |
| ☝ ⏵︎Revise          | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise                                                 ☑ ◉End.:success    | ⛾ ⏵︎Revise ⏵︎Notify approver ☝ ⏵︎Revise form ⏵︎Notify approver                           ☑ ◉End.:success    |
| ☝ ⏵︎Delete          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Delete ⏵︎Cancel                                         ☑ ◉End.:success    | ⛾ ◉End.success             ☝ ◉End.success                                            ☑ ◉End.:success    |
| ☝ ⏵︎Cancel          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Delete ⏵︎Cancel                                         ☑ ◉End.:success    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish                     ☑ ◉End.:success    |
| ☝ ⏵︎Archive         | ⛾ ⏵︎Archive                 ☝ ⏵︎Archive                                                ☑ ◉End.:success    | ⛾ ◉End.success             ☝ ◉End.success                                            ☑ ◉End.:success    |
| ☝ ⏵︎Revise ⛞        | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise                                                 ☑ ◉End.:success    | ⛾ ⏵︎Revise                  ☝ ⏵︎Revise                                                 ☑ ◉End.:success    |
| ☝ ⏵︎Revise form     | ⛾ ⏵︎Revise ⏵︎Notify approver ☝ ⏵︎Revise form ⏵︎Notify approver                           ☑ ◉End.:success    | ⛾ ⏵︎Revise ⏵︎Notify approver ☝ ⏵︎Revise                                                 ☑ ◉End.:success    |
+--------------------+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------+
=end

require "test_helper"

Posting::Endpoint

class Posting_CollaborationCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Test::Assertions
  require "trailblazer/test/assertions"
  include Trailblazer::Test::Assertions # DISCUSS: this is for assert_advance and friends.


  it "can run the collaboration" do
    schema = Posting::Collaboration::Schema
    # TODO: do this in an initializer?
    test_plan = Trailblazer::Workflow::Introspect::Iteration::Set::Deserialize.(JSON.parse(File.read("app/concepts/posting/collaboration/generated/iteration_set.json")), lanes_cfg: schema.to_h[:lanes])


    # DISCUSS: here, we technically should go through all possible paths. This is, to a certain degree, possible with discovery automation.
    # DISCUSS: also, we could automatically test not allowed transitions.

    # test: ☝ ⏵︎Create form
    ctx = assert_advance "☝ ⏵︎Create form", test_plan: test_plan, schema: schema
    # assert_exposes ctx, seq: [:revise, :revise], reader: :[]
    assert_equal ctx[:"contract.default"].class, Posting::Operation::Create::Form
    assert_equal ctx[:"contract.default"].content, nil


    # test: ☝ ⏵︎Create
    ctx = assert_advance "☝ ⏵︎Create", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Exciting times!"}}}, flow_options: Blog9::FLOW_OPTIONS
    assert_equal ctx[:contract].class, Posting::Operation::Create::Form
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "created"

    original_model = ctx[:model]

    # test: ☝ ⏵︎Notify approver
    ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "waiting for review"

  #@ invalid transition
  # test: ☝ ⏵︎Publish
  ctx = assert_advance "☝ ⏵︎Publish", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, invalid: true
  assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "waiting for review" # still in old mode.


    # test: ☑ ⏵︎Approve
    ctx = assert_advance "☑ ⏵︎Approve", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "approved, ready to publish"


    # test: ☝ ⏵︎Publish
    ctx = assert_advance "☝ ⏵︎Publish", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model], controller: Rails.application.routes.url_helpers}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "published"


    # test: ☝ ⏵︎Archive
    ctx = assert_advance "☝ ⏵︎Archive", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "archived"


# rerun: ☝ ⏵︎Create
ctx = assert_advance "☝ ⏵︎Create", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Exciting times!"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].class, Posting::Operation::Create::Form
assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "created"

original_model = ctx[:model]

# test: ☝ ⏵︎Update form
ctx = assert_advance "☝ ⏵︎Update form", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].class, Posting::Operation::Create::Form
assert_equal ctx[:contract].content, "Exciting times!"

# test: ☝ ⏵︎Update
ctx = assert_advance "☝ ⏵︎Update", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Exciting day"}}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: "updated"
  assert_equal original_model.id, ctx[:model].id

# test: ☝ ⏵︎Notify approver
ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: "waiting for review"


# test: ☑ ⏵︎Reject
ctx = assert_advance "☑ ⏵︎Reject", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model], review: Review.new(suggestions: "you can do better!", posting_id: ctx[:model].id)}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: "edit requested"
assert_equal ctx[:model].review.posting, ctx[:model]

# test: ☝ ⏵︎Revise form
ctx = assert_advance "☝ ⏵︎Revise form", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].content, "Exciting day"
# TODO: also test review suggestions.

# test: ☝ ⏵︎Revise
ctx = assert_advance "☝ ⏵︎Revise", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Truly epic"}}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "revised, ready to request review", id: original_model.id # FIXME: state label is confusing

# test: ☝ ⏵︎Revise ⛞
ctx = assert_advance "☝ ⏵︎Revise ⛞", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: ""}}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "revised, ready to request review", id: original_model.id # {content} hasn't changed.



# test: ☝ ⏵︎Notify approver
ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "waiting for review"

# test: ☑ ⏵︎Approve
ctx = assert_advance "☑ ⏵︎Approve", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "approved, ready to publish"

# test: ☝ ⏵︎Delete? form
ctx = assert_advance "☝ ⏵︎Delete? form", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
# assert_equal ctx[:contract].class, Posting::Operation::Create::Form
assert_equal ctx[:model].id, original_model.id # we need the ID as a hidden field.

# test: ☝ ⏵︎Cancel
ctx = assert_advance "☝ ⏵︎Cancel", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: "approved, ready to publish"

# test: ☝ ⏵︎Delete
ctx = assert_advance "☝ ⏵︎Delete", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: false, content: "Truly epic", state: "approved, ready to publish", id: original_model.id

# TEST INVALID FORM SUBMISSIONS
# test: ☝ ⏵︎Create ⛞
ctx = assert_advance "☝ ⏵︎Create ⛞", test_plan: test_plan, schema: schema, ctx: {params: {posting: {}}}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].errors.messages.inspect, %({:content=>["can't be blank"]})

# (2) test: ☝ ⏵︎Create
    ctx = assert_advance "☝ ⏵︎Create", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Exciting times!"}}}, flow_options: Blog9::FLOW_OPTIONS
# test: ☝ ⏵︎Update ⛞
ctx = assert_advance "☝ ⏵︎Update ⛞", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: ""}}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].errors.messages.inspect, %({:content=>["can't be blank"]})
  end
end
