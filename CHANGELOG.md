### next

* TODO: Replace this bullet point with an actual description of a change.

### 2.5.0 (19 January 2026)

* TODO: Replace this bullet point with an actual description of a change.

### 2.4.0 (7 January 2026)

* Upgraded to Ubuntu 24.04 on Github Actions ([#41](https://github.com/hausgold/factory_bot_instrumentation/pull/41))
* Migrated to hausgold/actions@v2 ([#40](https://github.com/hausgold/factory_bot_instrumentation/pull/40))

### 2.3.0 (26 December 2025)

* Added Ruby 4.0 support ([#39](https://github.com/hausgold/factory_bot_instrumentation/pull/39))
* Dropped Ruby 3.2 and Rails 7.1 support ([#38](https://github.com/hausgold/factory_bot_instrumentation/pull/38))

### 2.2.0 (19 December 2025)

* Migrated to a shared Rubocop configuration for HAUSGOLD gems ([#37](https://github.com/hausgold/factory_bot_instrumentation/pull/37))

### 2.1.0 (23 October 2025)

* Added support for Rails 8.1 ([#35](https://github.com/hausgold/factory_bot_instrumentation/pull/35))
* Switched from `ActiveSupport::Configurable` to a custom implementation based
  on `ActiveSupport::OrderedOptions` ([#36](https://github.com/hausgold/factory_bot_instrumentation/pull/36))

### 2.0.0 (28 June 2025)

* Corrected some RuboCop glitches ([#33](https://github.com/hausgold/factory_bot_instrumentation/pull/33))
* Drop Ruby 2 and end of life Rails (<7.1) ([#34](https://github.com/hausgold/factory_bot_instrumentation/pull/34))

### 1.7.1 (14 March 2025)

* Corrected some RuboCop glitches ([#30](https://github.com/hausgold/factory_bot_instrumentation/pull/30))
* Upgraded the rubocop dependencies ([#31](https://github.com/hausgold/factory_bot_instrumentation/pull/31))
* Corrected a frontend error typo ([#32](https://github.com/hausgold/factory_bot_instrumentation/pull/32))

### 1.7.0 (30 January 2025)

* Added all versions up to Ruby 3.4 to the CI matrix ([#29](https://github.com/hausgold/factory_bot_instrumentation/pull/29))

### 1.6.1 (17 January 2025)

* Added the logger dependency ([#28](https://github.com/hausgold/factory_bot_instrumentation/pull/28))

### 1.6.0 (12 January 2025)

* Switched to Zeitwerk as autoloader ([#27](https://github.com/hausgold/factory_bot_instrumentation/pull/27))

### 1.5.1 (9 January 2025)

* Sometimes the classic Rails autoloader is confused our engines
  `RootController` does not inherit our engines `ApplicationController`, but
  the one from host application, so we specify our dependency explicitly ([#26](https://github.com/hausgold/factory_bot_instrumentation/pull/26))

### 1.5.0 (7 January 2025)

* Switched from `ActionController::API` to `ActionController::Base` for the
  engine's `ApplicationController` ([#25](https://github.com/hausgold/factory_bot_instrumentation/pull/25))

### 1.4.1 (6 January 2025)

* Reverted (#23) as it causes errors for unknown reasons ([#24](https://github.com/hausgold/factory_bot_instrumentation/pull/24))

### 1.4.0 (6 January 2025)

* Moved the instrumentation methods (`#instrumentation`, `#scenarios`,
  `#groups`, `#scenario_group`) from the `RootController` to the
  `ApplicationController` ([#23](https://github.com/hausgold/factory_bot_instrumentation/pull/23))

### 1.3.0 (3 January 2025)

* Raised minimum supported Ruby/Rails version to 2.7/6.1 ([#22](https://github.com/hausgold/factory_bot_instrumentation/pull/22))

### 1.2.4 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.3 (15 August 2024)

* Just a retag of 1.2.1

### 1.2.2 (9 August 2024)

* Just a retag of 1.2.1

### 1.2.1 (9 August 2024)

* Added API docs building to continuous integration ([#21](https://github.com/hausgold/factory_bot_instrumentation/pull/21))

### 1.2.0 (8 July 2024)

* Dropped support for Ruby <2.7 ([#20](https://github.com/hausgold/factory_bot_instrumentation/pull/20))

### 1.1.5 (18 February 2024)

* Added fallbacks for configuration processing ([#19](https://github.com/hausgold/factory_bot_instrumentation/pull/19))

### 1.1.4 (5 January 2024)

* Pinned factory_bot down to < 6.4.5 in order to support Ruby 2.5 ([#18](https://github.com/hausgold/factory_bot_instrumentation/pull/18))
* Added handling to support Psych 4 and 5 ([#18](https://github.com/hausgold/factory_bot_instrumentation/pull/18))

### 1.1.3 (18 December 2023)

* Corrected the fallback view path configuration ([#17](https://github.com/hausgold/factory_bot_instrumentation/pull/17))

### 1.1.2 (18 December 2023)

* Moved the development dependencies from the gemspec to the Gemfile ([#15](https://github.com/hausgold/factory_bot_instrumentation/pull/15))
* Added a fallback view path handling in case an Rails application cannot
  find our engine templates correctly ([#16](https://github.com/hausgold/factory_bot_instrumentation/pull/16))

### 1.1.1 (24 February 2023)

* Removed double bundler/gem_tasks handling

### 1.1.0 (24 February 2023)

* Added support for Gem release automation

### 1.0.2 (15 February 2023)

* When used in combination with the `factory_bot_rails` gem (>= 6.0) we do not
  force a `FactoryBot.reload` at Rails engine initialization as it breaks with
  an `FactoryBot::DuplicateDefinitionError` ([#14](https://github.com/hausgold/factory_bot_instrumentation/pull/14))

### 1.0.1 (15 February 2023)

* Added a retry logic to the FactoryBot reloading on the POST/create endpoint
  in order to handle parallel requests properly ([#13](https://github.com/hausgold/factory_bot_instrumentation/pull/13))

### 1.0.0 (18 January 2023)

* Bundler >= 2.3 is from now on required as minimal version ([#12](https://github.com/hausgold/factory_bot_instrumentation/pull/12))
* Dropped support for Ruby < 2.5 ([#12](https://github.com/hausgold/factory_bot_instrumentation/pull/12))
* Dropped support for Rails < 5.2 ([#12](https://github.com/hausgold/factory_bot_instrumentation/pull/12))
* Updated all development/runtime gems to their latest
  Ruby 2.5 compatible version ([#12](https://github.com/hausgold/factory_bot_instrumentation/pull/12))

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
  handling on FactoryBot usage ([#9](https://github.com/hausgold/factory_bot_instrumentation/pull/9))

### 0.5.1 (12 May 2020)

* Corrected a bug on the scenario description update ([#8](https://github.com/hausgold/factory_bot_instrumentation/pull/8))

### 0.5.0 (20 January 2020)

* Added support for custom before action logics ([#7](https://github.com/hausgold/factory_bot_instrumentation/pull/7))

### 0.4.0 (9 December 2019)

* Added support for configurable rendering ([#6](https://github.com/hausgold/factory_bot_instrumentation/pull/6))

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
