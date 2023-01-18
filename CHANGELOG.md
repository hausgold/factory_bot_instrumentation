### next

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
