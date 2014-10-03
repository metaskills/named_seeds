# NamedSeeds

**Almost Ready for Rails 4.2.0.beta2**

* [Various Issues With 4.2.0.beta2 DB Setup/Testing](https://github.com/rails/rails/issues/17170)
* [The `test:prepare` Task Might Be Useless Now?](https://github.com/rails/rails/issues/17171)

**Make your tests fast by augmenting them with transactional fixtures powered by your favorite factory library!**

We all know that ActiveRecord::Fixtures are hard to maintain and are disconnected from the models that save your data. But Rails did get something right with transactional tests and easy helper methods to access fixtures by name. NamedSeeds aims to be a drop-in replacement for Rails fixtures or an enhancement to RSpec and Cucumber while using any object generator of your choice!

The idea is to leverage your tests' existing factories to generate fixtures that will be populated before testing starts and to use a database transaction strategy around each test. In this way you have a populated story that can be accessed via convienient helper methods like `users(:admin)` which in turn yields much faster test runs. Database fixtures, even those seeded by factories, are not a panacea and we highly suggested that you continue to use factories in your tests when it makes sense to do so. For those that think this is mad or have FUD to share, please see my blog articles:

* Inprogress...
* Inprogress...


## Versions

The current master branch is for Rails v4.2.0 and up and follows v1.1 major version. Please use our `1-0-stable` branch for Rails v3.1 to v4.1.


## Installation

Add the named_seeds gem to your Rails' Gemfile in both the development and test group as shown below. This is needed as the NamedSeeds gem exposes rake tasks needed in both environments.

```ruby
group :development, :test do
  gem 'named_seeds'
end
```

Next add, `NamedSeeds.prepare` to your test helper after the Rails test help file is required. For example:

```ruby
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
NamedSeeds.prepare
```

## Usage

NamedSeeds requires that you create a `db/test/seeds.rb` file. The contents of this file can be anything you want. We recommend using a factory library like [FactoryGirl](https://github.com/thoughtbot/factory_girl) or [Machinist](https://github.com/notahat/machinist).

```ruby
require 'factory_girl'
FactoryGirl.find_definitions rescue false

@bob = FactoryGirl.create :user, id: NamedSeeds.identify(:bob), email: 'bob@test.com'
```

Use the `NamedSeeds.identify` method to give a name to the identity used for this record. You will be able to find this record using that name later on.


#### Integration Notes

The NamedSeeds gem will hook into Rails/ActiveRecord's `db:setup` task. This means that new developers can checkout your code and run the normal Rails setup process and see a fully populated development database that has the same seed/fixtures story used by your tests. For example:

```
$ bundle
$ rake db:create:all
$ rake db:setup
```

If you need to force a reload of your development environment's data, just use Rails conventions. For example, the `db:reset` task calls setup, so NamedSeeds will hook in at the right place.

```
$ rake db:reset
```

Likewise, if you wanted to reset your test database and pre-populate it with named seeds/fixtures you can run the following:

```
$ spring stop && rake db:reset RAILS_ENV=test
```

#### Rails

By default, Rails' ActiveSupport::TestCase has set the `use_transactional_fixtures` to true. So all you need to do is declare which tables have NamedSeeds keys.

```ruby
class ActiveSupport::TestCase
  named_seeds :users, :posts
end
```

Now you can use both the `users` and `posts` helper methods to find any named identity from your seed file.

```ruby
require 'test_helper'
class UserTest < ActiveSupport::TestCase
  setup { @user = users(:bob) }
  tests "should work" do
    assert_equal 'bob@test.com', @user.posts
  end
end
```

#### RSpec

Coming soon...

#### Cucumber

Coming soon...



## Configurations

NamedSeeds is a `Rails::Railtie` that exposes a few `config` options. So open up the `config/environments/development.rb` **(yes in development.rb)** and use the `config.named_seeds` options below. NOTE: I have found that sometimes I need to add some configurations to `config/environments/test.rb` too.

* *app_load_seed* - Load your Rails application's db/seeds.rb file into the test database. This is done before db/test/seeds.rb is loaded. Default is `true` but may people use this file incorrectly vs standard lookup tables.
* *engines_with_load_seed* - Some Rails engines provide a load seed hook. If you want NamedSeed to call the engine's seed method into your tests database, push the engine constant to this array. Any object responding to `load_seed` sould work here too. Default is an empty array.

```ruby
My::Application.configure do
  config.named_seeds.app_load_seed = false
  config.named_seeds.engines_with_load_seed += [GeoData::Engine, OurLookupTables]
end
```

NamedSeeds relies on ActiveRecord's `ActiveRecord::Migration.maintain_test_schema!` setting. We do not want to get into the business of coupling too much with the internals of Rails and hance assume this is true.


## Todo

Show Rails implementation using ActiveSupport::TestCase or RSpec.

Show examples with these 3 factory libraries.

* https://github.com/thoughtbot/factory_girl
* https://github.com/paulelliott/fabrication
* https://github.com/notahat/machinist

Set up a dummy_application in test.

How are we different from:

* https://github.com/mbleigh/seed-fu
* https://github.com/sevenwire/bootstrapper/
* https://github.com/franciscotufro/environmental_seeder

Talk about http://railscasts.com/episodes/179-seed-data
