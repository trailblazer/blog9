# README

## Editor

The workflow for this example is designed with our [Trailblazer PRO](https://pro.trailblazer.to) editor.

![BPMN2 diagram with TRB flavoring for a blog post moderation workflow.](https://github.com/trailblazer/blog9/blob/main/doc/moderation-version-10.png?raw=true)

This is still WIP and will soon look less clumsy.

## Notes

1. `main` branch is deliberately using ActionView and _not_ Cells to not further steepen your learning curve.


## More notes

```
rails g trailblazer:pro:install
rails g trailblazer:pro:import 9661db app/concepts/posting/collaboration/generated/posting-v10.json
rails g trailblazer:pro:discover Posting::Collaboration::Schema "<ui> author workflow"  app/concepts/posting/collaboration/generated/iteration_set.json --test test/posting_collaboration_test.rb --failure UI:Create,lifecycle:Create --failure UI:Update,lifecycle:Update
```
