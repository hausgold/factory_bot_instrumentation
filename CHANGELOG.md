### next

* TODO: Replace this bullet point with an actual description of a change.

### 1.3.0 (3 January 2025)

* Raised minimum supported Ruby/Rails version to 2.7/6.1 (#22)

### 1.2.4 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.3 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.2 (9 August 2024)

* Just a retag of 1.2.1

### 1.2.1 (9 August 2024)

* Added API docs building to continuous integration (#21)

### 1.2.0 (8 July 2024)

* Dropped support for Ruby <2.7 (#20)

### 1.1.5 (18 February 2024)

* Added fallbacks for configuration processing (#19)

### 1.1.4 (5 January 2024)

* Pinned factory_bot down to < 6.4.5 in order to support Ruby 2.5 (#18)
* Added handling to support Psych 4 and 5 (#18)

### 1.1.3 (18 December 2023)

* Corrected the fallback view path configuration (#17)

### 1.1.2 (18 December 2023)

* Moved the development dependencies from the gemspec to the Gemfile (#15)
* Added a fallback view path handling in case an Rails application cannot
  find our engine templates correctly (#16)

### 1.1.1 (24 February 2023)

* Removed double bundler/gem_tasks handling

### 1.1.0 (24 February 2023)

* Added support for Gem release automation

### 1.0.2 (15 February 2023)

* When used in combination with the `factory_bot_rails` gem (>= 6.0) we do not
  force a `FactoryBot.reload` at Rails engine initialization as it breaks with
  an `FactoryBot::DuplicateDefinitionError` (#14)

### 1.0.1 (15 February 2023)

* Added a retry logic to the FactoryBot reloading on the POST/create endpoint
  in order to handle parallel requests properly (#13)

### 1.0.0 (18 January 2023)

* Bundler >= 2.3 is from now on required as minimal version (#12)
* Dropped support for Ruby < 2.5 (#12)
* Dropped support for Rails < 5.2 (#12)
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version (#12)

### 0.8.0 (10 December 2021)

* Added `FactoryBot.reload` to the initializer code to ensure the factories
  are in place.

### 0.7.1 (15 October 2021)

* Migrated to Github Actions
* Migrated to our own coverage reporting

### 0.7.0 (15 October 2021)

* Dropped Rails 4 support

### 0.6.0 (21 September 2020)

* Added support for custom error handling and improved the default error
  handling on FactoryBot usage (#9)

### 0.5.1 (12 May 2020)

* Corrected a bug on the scenario description update (#8)

### 0.5.0 (20 January 2020)

* Added support for custom before action logics (#7)

### 0.4.0 (9 December 2019)

* Added support for configurable rendering (#6)

### 0.3.0 (15 July 2019)

* Removed CI support for Ruby 2.3 (it never worked before)
* Fixed the overwrite params bug on Rails 4.2
* Added a test suite for the engine

### 0.2.0 (22 March 2019)

* Removed the Gemfile locks and added the to the ignore list
* Dropped Rails 3 support
* Added support for Bundler 1 and 2

### 0.1.0 (9 January 2019)

* Added the initial code base
