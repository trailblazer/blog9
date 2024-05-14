=begin
  +--------------------+--------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| triggered catch    | start configuration                                                                                                                        | expected reached configuration                                                                                                             |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
| ☝ ⏵︎Create form     | ⛾ ⏵︎Create <0wwf>                  ☝ ⏵︎Create form <0wc2>                                                          ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Create <0wwf>                  ☝ ⏵︎Create <14h0>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Create          | ⛾ ⏵︎Create <0wwf>                  ☝ ⏵︎Create <14h0>                                                               ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update form ⏵︎Notify approver <0kkn>                                         ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Create ⛞        | ⛾ ⏵︎Create <0wwf>                  ☝ ⏵︎Create <14h0>                                                               ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Create <0wwf>                  ☝ ⏵︎Create <14h0>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Update form     | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update form ⏵︎Notify approver <0kkn>                                         ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update <0nxe>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Notify approver | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update form ⏵︎Notify approver <0kkn>                                         ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Reject ⏵︎Approve <0y3f>         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 <063k> ☑ ⏵︎Approve ⏵︎Reject <02ve> |
| ☝ ⏵︎Update          | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update <0nxe>                                                               ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Notify approver ⏵︎Update <1wzo> ☝ ⏵︎Update form ⏵︎Notify approver <1g3f>                                         ☑ ⏵︎Notify <05zi>          |
| ☑ ⏵︎Approve         | ⛾ ⏵︎Reject ⏵︎Approve <0y3f>         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 <063k> ☑ ⏵︎Approve ⏵︎Reject <02ve> | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish <1sq4>                                   ☑ ⏵︎Notify <05zi>          |
| ☑ ⏵︎Reject          | ⛾ ⏵︎Reject ⏵︎Approve <0y3f>         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 <063k> ☑ ⏵︎Approve ⏵︎Reject <02ve> | ⛾ ⏵︎Revise <01p7>                  ☝ ⏵︎Revise form <0zso>                                                          ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Update ⛞        | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update <0nxe>                                                               ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Update ⏵︎Notify approver <0fnb> ☝ ⏵︎Update <0nxe>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Update form     | ⛾ ⏵︎Notify approver ⏵︎Update <1wzo> ☝ ⏵︎Update form ⏵︎Notify approver <1g3f>                                         ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Notify approver ⏵︎Update <1wzo> ☝ ⏵︎Update <0nxe>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Notify approver | ⛾ ⏵︎Notify approver ⏵︎Update <1wzo> ☝ ⏵︎Update form ⏵︎Notify approver <1g3f>                                         ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Reject ⏵︎Approve <0y3f>         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 <063k> ☑ ⏵︎Approve ⏵︎Reject <02ve> |
| ☝ ⏵︎Update form     | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish <1sq4>                                   ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Update <0nxe>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Delete? form    | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish <1sq4>                                   ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Delete ⏵︎Cancel <100g>                                                       ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Publish         | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish <1sq4>                                   ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Archive <1hgs>                 ☝ ⏵︎Archive <0fy4>                                                              ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Revise form     | ⛾ ⏵︎Revise <01p7>                  ☝ ⏵︎Revise form <0zso>                                                          ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Revise <01p7>                  ☝ ⏵︎Revise <1xs9>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Delete          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Delete ⏵︎Cancel <100g>                                                       ☑ ⏵︎Notify <05zi>          | ⛾ ◉End.success <1p88>             ☝ ◉End.success <0h6y>                                                          ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Cancel          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Delete ⏵︎Cancel <100g>                                                       ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Publish ⏵︎Delete ⏵︎Update <1hp2> ☝ ⏵︎Update form ⏵︎Delete? form ⏵︎Publish <1sq4>                                   ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Archive         | ⛾ ⏵︎Archive <1hgs>                 ☝ ⏵︎Archive <0fy4>                                                              ☑ ⏵︎Notify <05zi>          | ⛾ ◉End.success <1p88>             ☝ ◉End.success <0h6y>                                                          ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Revise          | ⛾ ⏵︎Revise <01p7>                  ☝ ⏵︎Revise <1xs9>                                                               ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Revise ⏵︎Notify approver <1kl7> ☝ ⏵︎Revise form ⏵︎Notify approver <1xns>                                         ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Revise ⛞        | ⛾ ⏵︎Revise <01p7>                  ☝ ⏵︎Revise <1xs9>                                                               ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Revise <01p7>                  ☝ ⏵︎Revise <1xs9>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Revise form     | ⛾ ⏵︎Revise ⏵︎Notify approver <1kl7> ☝ ⏵︎Revise form ⏵︎Notify approver <1xns>                                         ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Revise ⏵︎Notify approver <1kl7> ☝ ⏵︎Revise <1xs9>                                                               ☑ ⏵︎Notify <05zi>          |
| ☝ ⏵︎Notify approver | ⛾ ⏵︎Revise ⏵︎Notify approver <1kl7> ☝ ⏵︎Revise form ⏵︎Notify approver <1xns>                                         ☑ ⏵︎Notify <05zi>          | ⛾ ⏵︎Reject ⏵︎Approve <0y3f>         ☝ ⏵︎suspend-Gateway_1sq41iq ⏵︎suspend-gw-to-catch-before-Activity_0zsock2 <063k> ☑ ⏵︎Approve ⏵︎Reject <02ve> |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------+
=end

require "test_helper"

Posting::Endpoint

class Posting_CollaborationCollaborationTest < Minitest::Spec
  include Trailblazer::Workflow::Test::Assertions
  require "trailblazer/test/assertions"
  include Trailblazer::Test::Assertions # DISCUSS: this is for assert_advance and friends.


  it "can run the collaboration" do
    state_map_fixme = {
      "created" => "⏸︎ Update form♦Notify approver [000]",
      "waiting for review" => "⏸︎ Approve♦Reject [000]",
      "approved, ready to publish" => "⏸︎ Update form♦Delete? form♦Publish [110]",
      "published" => "⏸︎ Archive [100]",
      "updated" => "⏸︎ Update form♦Notify approver [110]",
      "edit requested" => "⏸︎ Revise [010]",
      "revised, ready to request review" => "⏸︎ Revise form♦Notify approver [110]",
      "approved, ready to publish" => "⏸︎ Update form♦Delete? form♦Publish [110]",
    }

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
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: state_map_fixme["created"]

    original_model = ctx[:model]

    # test: ☝ ⏵︎Notify approver
    ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: state_map_fixme["waiting for review"]

  #@ invalid transition
  # test: ☝ ⏵︎Publish
  ctx = assert_advance "☝ ⏵︎Publish", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]},
    invalid: true
  assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: state_map_fixme["waiting for review"] # still in old mode.


    # test: ☑ ⏵︎Approve
    ctx = assert_advance "☑ ⏵︎Approve", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: state_map_fixme["approved, ready to publish"]


    # test: ☝ ⏵︎Publish
    ctx = assert_advance "☝ ⏵︎Publish", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model], controller: Rails.application.routes.url_helpers}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: state_map_fixme["published"]


    # test: ☝ ⏵︎Archive
    ctx = assert_advance "☝ ⏵︎Archive", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
    assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: "archived"


# rerun: ☝ ⏵︎Create
ctx = assert_advance "☝ ⏵︎Create", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Exciting times!"}}}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].class, Posting::Operation::Create::Form
assert_exposes ctx[:model], persisted?: true, content: "Exciting times!", state: state_map_fixme["created"]

original_model = ctx[:model]

# test: ☝ ⏵︎Update form
ctx = assert_advance "☝ ⏵︎Update form", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].class, Posting::Operation::Create::Form
assert_equal ctx[:contract].content, "Exciting times!"

# test: ☝ ⏵︎Update
ctx = assert_advance "☝ ⏵︎Update", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Exciting day"}}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: state_map_fixme["updated"]
  assert_equal original_model.id, ctx[:model].id

# test: ☝ ⏵︎Notify approver
ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: state_map_fixme["waiting for review"]


# test: ☑ ⏵︎Reject
ctx = assert_advance "☑ ⏵︎Reject", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model], review: ___review = Review.new(suggestions: "you can do better!", posting_id: ctx[:model].id)}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Exciting day", state: state_map_fixme["edit requested"]
assert_equal ctx[:model].review.posting, ctx[:model]

# test: ☝ ⏵︎Revise form
ctx = assert_advance "☝ ⏵︎Revise form", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_equal ctx[:contract].content, "Exciting day"
# TODO: also test review suggestions.

# test: ☝ ⏵︎Revise
ctx = assert_advance "☝ ⏵︎Revise", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: "Truly epic"}}, model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: state_map_fixme["revised, ready to request review"], id: original_model.id # FIXME: state label is confusing
revised_model = ctx[:model]

# test: ☝ ⏵︎Revise ⛞
rejected_model = Posting.create(state: state_map_fixme["edit requested"], content: ctx[:model].content, review: ___review)
# rejected_model.state = state_map_fixme["edit requested"] # DISCUSS: how can we automate state snapshots?
ctx = assert_advance "☝ ⏵︎Revise ⛞", test_plan: test_plan, schema: schema, ctx: {params: {posting: {content: ""}}, model: rejected_model}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: state_map_fixme["edit requested"], id: rejected_model.id # {content} hasn't changed.



# test: ☝ ⏵︎Notify approver
ctx = assert_advance "☝ ⏵︎Notify approver", test_plan: test_plan, schema: schema, ctx: {params: {}, model: revised_model}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: state_map_fixme["waiting for review"]

# test: ☑ ⏵︎Approve
ctx = assert_advance "☑ ⏵︎Approve", test_plan: test_plan, schema: schema, ctx: {params: {}, model: ctx[:model]}
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: state_map_fixme["approved, ready to publish"]

# test: ☝ ⏵︎Delete? form
ctx = assert_advance "☝ ⏵︎Delete? form", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
# assert_equal ctx[:contract].class, Posting::Operation::Create::Form
assert_equal ctx[:model].id, original_model.id # we need the ID as a hidden field.

# test: ☝ ⏵︎Cancel
ctx = assert_advance "☝ ⏵︎Cancel", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: true, content: "Truly epic", state: state_map_fixme["approved, ready to publish"]

# test: ☝ ⏵︎Delete
ctx = assert_advance "☝ ⏵︎Delete", test_plan: test_plan, schema: schema, ctx: {model: ctx[:model]}, flow_options: Blog9::FLOW_OPTIONS
assert_exposes ctx[:model], persisted?: false, content: "Truly epic", state: state_map_fixme["approved, ready to publish"], id: original_model.id

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
