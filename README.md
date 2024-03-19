# README

## Notes

1. `main` branch is deliberately using ActionView and _not_ Cells to not further steepen your learning curve.


## More notes

rails g trailblazer:pro:install
rails g trailblazer:pro:import 9661db app/concepts/posting/posting-v1.json
rails g trailblazer:pro:discover Posting::Collaboration::Schema "<ui> author workflow"  app/concepts/posting/posting-v1-discovered-iterations.json --test test/posting_collaboration_test.rb --failure UI:Create,lifecycle:Create --failure UI:Update,lifecycle:Update
