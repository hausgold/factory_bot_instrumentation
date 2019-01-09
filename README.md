![factory_bot_instrumentation](doc/assets/project.svg)

This project is dedicated to provide an API and frontend to
[factory_bot](https://github.com/thoughtbot/factory_bot) factories to generate
test data on demand. With the help of this gem your testers are able to
interact easily with the entities of your application by using predefined use
cases.

- [Installation](#installation)
- [Usage](#usage)
  - [Configuration](#configuration)
- [Development](#development)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory_bot_instrumentation'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install factory_bot_instrumentation
```

## Usage

### Configuration

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bundle exec rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hausgold/factory_bot_instrumentation.
