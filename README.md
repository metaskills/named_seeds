# NamedSeeds

**Make your tests fast by augmenting them with transactional fixtures powered by your favorite factory library!**

We all know that ActiveRecord::Fixtures suck because they are authored in YAML files. But Rails did get something right with transactional tests and easy helper methods to access fixtures by name. NamedSeeds aims to be a drop-in replacement for Rails fixtures or an enhancement to RSpec and Cucumber while using any object generator of your choice!

The idea is to leverage your tests' existing factories to generate fixtures that will be populated before testing starts and to use a database transaction strategy around each test. In this way you have a populated story that can be accessed via convienient helper methods like `users(:admin)` which in turn yields much faster test runs. Database fixtures, even those seeded by factories, are not a panacea and we highly suggested that you continue to use factories in your tests when it makes sense to do so. For those that think this is mad or have FUD to share, please see my blog articles:

* Inprogress...
* Inprogress...


## Installation

Add the named_seeds gem to your Rails' Gemfile in both the development and test group as shown below. This is needed as the NamedSeeds gem exposes rake tasks needed in both environments.

```ruby
group :development, :test do
  gem 'named_seeds'
end
```

## Usage

NamedSeeds requires that you create a `db/test/seeds.rb` file. The contents of this file can be anything you want. We recommend using a factory library like [FactoryGirl](https://github.com/thoughtbot/factory_girl) or [Machinist](https://github.com/notahat/machinist).

```ruby
require 'factory_girl'
FactoryGirl.reload

@bob = FactoryGirl.create :user, :id => NamedSeeds.identify(:bob), :email => 'bob@test.com'
```

Use the `NamedSeeds.identify` method to give a name to the identity used for this record. You will be able to find this record using that name later on.


### Rake Files

**Using these tasks manually should not be needed as both are hooked into the proper `test:prepare` and `db:setup` process for you.**

NamedSeeds includes two rake tasks. The `db:test:seeds` is the one that does all the work and is automatically called after Rails' `test:prepare` for you. So running your rake test tasks will create your test database and seed it for you automatically before your tests run. Remember, ActiveRecords `db:test:prepare` is not a proper hook, read [my comment](https://github.com/rspec/rspec-rails/issues/663#issuecomment-11831559) on this rspec issue for more details.

The other task is `db:development:seed`. This task invokes the normal Rails `db:seed` task, then loads the db/test/seeds.rb file while still in development mode. We automatically call this task after `db:setup` for you. This task provides a way for a developer to populate their development database with the same fixture story used for testing. This makes it easy for developers to learn your application as the test story is a 1 to 1 mapping of data in local development.

```shell
$ rake db:test:seed          # Run the seed data from db/test/seeds.rb and 
                             # optionally your Rails db/seeds.rb if you have 
                             # configured `app_load_seed` below.

$ rake db:development:seed   # Runs the normal Rails `db:seed` task then 
                             # loads the db/test/seeds.rb file.
```


#### Rails

By default, Rails' ActiveSupport::TestCase has set the `use_transactional_fixtures` to true. So all you need to do is declare which tables have NamedSeeds keys.

```ruby
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

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


## Advanced Usage

Review how helper methods may map to custom table names. Like Rails did with #fixture_table_names...


## Configurations

NamedSeeds is a `Rails::Railtie` that exposes a few `config` options. So open up the `config/environments/development.rb` **(yes in development.rb)** and use the `config.named_seeds` options below. NOTE: I have found that sometimes I need to add some configurations to `config/environments/test.rb` too. Mainly when using [spring](https://github.com/jonleighton/spring). So adding `config.named_seeds.app_load_seed = true` is what I needed.


* *app_load_seed* - Load your Rails application's db/seeds.rb file into the test database. This is done before db/test/seeds.rb is loaded. Default is false.
* *engines_with_load_seed* - Some Rails engines provide a load seed hook. If you want NamedSeed to call the engine's seed method into your tests database, push the engine constant to this array. Any object responding to `load_seed` sould work here too. Default is an empty array.

```ruby
My::Application.configure do
  config.named_seeds.app_load_seed = true
  config.named_seeds.engines_with_load_seed += [GeoData::Engine, OurLookupTables]
end
```

NamedSeeds uses DatabaseCleaner to clean the database before seeding it. Use the `config.named_seeds.db_cleaner` options below to configure its behavior. Please see the DatabaseCleaner documentation for full details.

* *orm* - The ORM module to use. Default is `:active_record`.
* *connection* - The connection name to use. Default is `:test`.
* *strategy* - Strategy to clean the database with. Default is `:truncation`.
* *strategy_args* - Args to be passed to the strategy. Default is an empty hash.

```ruby
My::Application.configure do
  config.named_seeds.db_cleaner.orm           = :active_record
  config.named_seeds.db_cleaner.connection    = :test
  config.named_seeds.db_cleaner.strategy      = :truncation
  config.named_seeds.db_cleaner.strategy_args = {:except => ['geodata', 'lookuptable']}
end
```



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
