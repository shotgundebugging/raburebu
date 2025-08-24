Runnable RSpec test templates, organized by Rails subsystem for isolation and reproducibility.

## Structure

- Each subsystem (ActiveRecord, ActionPack, etc.) has its own folder, Gemfile, and minimal test app.
- To run a bug report spec for a subsystem, navigate to its folder and run `bundle install && bundle exec rspec`.

## Example

```bash
cd ActiveRecord
bundle install
bundle exec rspec
```

