### next

* Added fallbacks for configuration processing (#19)

### 1.1.4

* Pinned factory_bot down to < 6.4.5 in order to support Ruby 2.5 (#18)
* Added handling to support Psych 4 and 5 (#18)

### 1.1.3

* Corrected the fallback view path configuration (#17)

### 1.1.2

* Moved the development dependencies from the gemspec to the Gemfile (#15)
* Added a fallback view path handling in case an Rails application cannot
  find our engine templates correctly (#16)

### 1.1.1

* Removed double bundler/gem_tasks handling

### 1.1.0

* Added support for Gem release automation

### 1.0.2

* When used in combination with the `factory_bot_rails` gem (>= 6.0) we do not
  force a `FactoryBot.reload` at Rails engine initialization as it breaks with
  an `FactoryBot::DuplicateDefinitionError` (#14)

### 1.0.1

* Added a retry logic to the FactoryBot reloading on the POST/create endpoint
  in order to handle parallel requests properly (#13)

### 1.0.0

* Bundler >= 2.3 is from now on required as minimal version (#12)
* Dropped support for Ruby < 2.5 (#12)
* Dropped support for Rails < 5.2 (#12)
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version (#12)

### 0.8.0

* Added `FactoryBot.reload` to the initializer code to ensure the factories
  are in place.

### 0.7.1

* Migrated to Github Actions
* Migrated to our own coverage reporting

### 0.7.0

* Dropped Rails 4 support

### 0.6.0

* Added support for custom error handling and improved the default error
  handling on FactoryBot usage (#9)

### 0.5.1

* Corrected a bug on the scenario description update (#8)

### 0.5.0

* Added support for custom before action logics (#7)

### 0.4.0

* Added support for configurable rendering (#6)

### 0.3.0

* Removed CI support for Ruby 2.3 (it never worked before)
* Fixed the overwrite params bug on Rails 4.2
* Added a test suite for the engine

### 0.2.0

* Removed the Gemfile locks and added the to the ignore list
* Dropped Rails 3 support
* Added support for Bundler 1 and 2

### 0.1.0

* Added the initial code base
