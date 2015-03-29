
<img width="502" height="298" alt="NamedSeeds - When it comes to fast tests... you reap what you sow!" src="https://cloud.githubusercontent.com/assets/2381/6770492/c7093fa6-d097-11e4-9e1f-6f90a857f8d3.png" />

<hr>

**Make your tests fast by augmenting them with transactional fixtures
powered by your favorite factory library!**

We all know that ActiveRecord's fixtures are hard to maintain, and more importantly, disconnected from the models that create your data. This disconnect can lead to invalid or incomplete representations of your objects as your application grows. But Rails did get something right. Fixtures combined with transactional tests are a huge performance win while providing [canned references among your team](http://martinfowler.com/bliki/ObjectMother.html) via helper methods that find fixtures using a unique name. The NamedSeeds gem aims to replace YAML fixtures by providing a slim identification layer to be used in conjunction with your factory library of choice. For example, [FactoryGirl](https://github.com/thoughtbot/factory_girl).

The idea is to leverage your tests' existing factories to generate fixtures that will be populated before testing starts and to use a database transaction strategy around each test. In this way you have a curated set of personas that can be accessed via convenient helper methods like `users(:admin)` which in turn yields much faster test runs. **NamedSeeds fixtures also become your seed data for Rails' development environment.** This consistency between development and testing is a huge win for on-boarding new team members. Lastly, database fixtures, even those seeded by factories, are not a panacea and we recommend that you continue to use factories in your tests for edge cases when it makes sense to do so.

NamedSeeds is best when your factories follow two key principals:

* Leveraging your models for most business logic.
* Creation of "valid garbage" with no/minimal args while allowing idempotency via explicit args.


## Installation

Add the gem to your Rails' Gemfile in both the development and test group as shown below. This is needed since the NamedSeeds gem has integrations in both environments.

```ruby
group :development, :test do
  gem 'named_seeds'
end
```


## Quick Start

NamedSeeds only requires that you customize the Rails `db/seeds.rb` file. The contents of this file can be anything you want! We recommend using a factory library like [FactoryGirl](https://github.com/thoughtbot/factory_girl) or [Machinist](https://github.com/notahat/machinist).

```ruby
require 'factory_girl'
include FactoryGirl::Syntax::Methods
FactoryGirl.find_definitions rescue false
FactoryGirl.lint

@bob = create :user, id: NamedSeeds.identify(:bob), email: 'bob@test.com'
```

In this example we have given our Bob user an explicit primary key using the identify method of NamedSeeds. This ensures we have a handle on Bob in our tests. For this happen, make the following changes to your Rails `test_helper.rb` file.

```ruby
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
NamedSeeds.load_seed

class ActiveSupport::TestCase

  named_seeds :users

end
```

Here we have added `NamedSeeds.load_seed` after our requires. This ensures our test database is properly seeded. We have also added a `named_seeds :users` declaration that creates a test helper method that can find any persona with a matching identity. The method name follows ActiveRecord model/table name conventions. So in this case we expect to find a `User` model. An example of what our unit test for Bob might look like with the new `users` fixture helper would be:

```ruby
require 'test_helper'

class UserTest < ActiveSupport::TestCase

  tests "should work" do
    user = users(:bob)
    assert_equal 'bob@test.com', user.email
  end

end
```

This test is very contrived and is only meant to illustrate the `users(:bob)` test helper which closely mimics ActiveRecord's fixture helpers.


## Detailed Usage

#### Development Benefits

NamedSeeds hooks into the `db:setup` process. In this way, the same fixture story seeded in your test environment is the same in development. For example, if you are on-boarding a new developer and bootstrapping their environment.

```shell
$ bundle
$ rake db:create:all db:setup
```

Your local development database will now contain all fixtures created in db/seeds. As you fixtures grow, re-create your development environment with confidence.


```shell
$ bundle
$ rake db:drop:all db:create:all db:setup
```

#### The NamedSeeds::DSL

If you do not like typing `NamedSeeds.identify(:persona)` over and over again in your seeds file, you can include the `NamedSeeds::DSL` at the top. This will give you direct scope to the `identify` method which is also succinctly aliased to just `id` if you want.

```ruby
include NamedSeeds::DSL

id(:ruby)       # => 207281424
id(:sapphire_2) # => 1066363776
```

#### UUID Identifiers

By default identities boil down to a consistent integer whose values are less than 2^30. These are great for typical primary or foreign keys. Now that Rails supports UUID keys in both models and ActiveRecord fixtures, so does the NamedSeeds gem. The identity method can use an optional second parameter to denote the SQL type when seeding your database.

```ruby
id(:ken, :uuid) # => '4f156606-8cb3-509e-a177-956ca0a22015'
```

So if our `User` model did use a UUID column type, our seed file might look like this.

```ruby
@bob = create :user, id: NamedSeeds.identify(:bob), email: 'bob@test.com'
```

#### String Identifier

If your model uses strings for primary keys or what is known as "natural" keys, then NamedSeeds can still work for you. First, create your seed data without the identity helper. For example, below we are seeding US states in a contrived lookup table.

```ruby
# In db/seeds.rb file.
create :state, id: 'VA', name: 'Virginia'
create :state, id: 'WA', name: 'Washington'
```

Here the primary key of the `State` model is a string column. You have two options to generate test helpers for these objects. Note that none are technically needed since the identities are known and not random integers.

```ruby
named_seeds :states, identities: {virginia: 'VA', washington: 'WA'}
states(:virginia) # => #<State id: 'VA'... >

named_seeds :states, identities: :natural
states('VA')      # => #<State id: 'VA'... >

```

By passing an identities hash to `named_seeds` you can customize the name of the key used in finders. The first line would generate a method that allows you to find states using the longer identities key values. This is great if your natural keys do not necessarily speak to the persona/object under test. If you wanted to use the natural key string values, you can just pass `:natural` to the identities option.

#### Setting Fixture Classes

If your test helper name can not infer the class name, just use the `:class` option when declaring seeds in your test helper.

```ruby
named_seeds :users, class: Legacy::User
```

#### Moving From ActiveRecord Fixtures

Unlike ActiveRecord fixtures, NamedSeeds does not support loading fixtures per test case. Since the entire fixture story is loaded before the test suite runs. NamedSeeds is much more akin to `fixtures(:all)` and the `named_seeds` method is more about creating test helper methods to access named fixtures. Lastly, NamedSeeds has no notion of instantiated fixtures.

#### Using DatabaseCleaner

Rails 4 (maybe starting in 4.1) now has a new test database synchronization strategy. No longer is your entire development schema cloned when you run your tests. This saves time when running tests but it also adds a potential gotcha when using db/seeds.rb with the NamedSeeds gem. We recommend using the DatabaseCleaner gem and cleaning your DB at the top of your seed file.

```ruby
# In your Gemfile.
group :development, :test do
  gem 'named_seeds'
  gem 'database_cleaner'
end

# Top of db/seeds.rb file.
require 'database_cleaner'
DatabaseCleaner.clean_with :truncation
DatabaseCleaner.clean
```


## Configurations

All configurations are best done in a `config/initializers/named_seeds.rb` file using a defined check as shown below. All other examples below assume this convention.

```ruby
if defined?(NamedSeeds)
  Rails.application.config.named_seeds
end
```

#### Other Rails::Engine And Seed Loaders

Rails::Engines are a great way to distribute shared functionality. Rails exposes a hook called `load_seed` that an engine can implement. These are great for seeding tables that an engine's models may need. You can tell NamedSeeds to use any object that responds to `load_seed` and each will be called after `db/seeds.rb` is loaded. For example:

```ruby
config.named_seeds.engines_with_load_seed = [
  GeoData::Engine,
  OurLookupTables
]
```

#### Custom Seed File

By default, the NamedSeeds gem relies on Rails `db/seeds.rb` as your seed file. Some people use this file for setting up new production instances while others have code in this file that is something completely different. If this file is not safe for development/test then you should really re-examine your usage of `db/seeds.rb` since Rails loads this file on the `db:setup` task automatically. If you do not want to use this for your development/test seed data, then you can customize the location. However, NamedSeeds does this by running our own `named_seeds:setup` task after the Rails `db:setup` task. So the result is still somewhat the same for development but this does keep `db/seeds.rb` out of the test environment.

```ruby
config.named_seeds.load_app_seed_file = false
config.named_seeds.custom_seed_file = 'db/seeds_devtest.rb'
```


## Versions

The current master branch is for Rails v4.0.0 and up and. Please use our `1-0-stable` branch for Rails v3.x.


## Contributing

We use the [Appraisal](https://github.com/thoughtbot/appraisal) gem from Thoughtbot to help us test different versions of Rails. The `rake appraisal test` command actually runs our test suite against all Rails versions in our `Appraisal` file. So after cloning the repo, running the following commands.

```shell
$ bundle install
$ bundle exec appraisal install
$ bundle exec appraisal rake test
```

If you want to run the tests for a specific Rails version, use one of the appraisal names found in our `Appraisals` file. For example, the following will run our tests suite for Rails 4.1.x.

```shell
$ bundle exec appraisal rails41 rake test
```


