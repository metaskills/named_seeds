require 'active_record/base'

TESTING_RAILS_40 = Gem::Dependency.new('rails', '~> 4.0.0') =~ Gem::Dependency.new('rails', Rails::VERSION::STRING)
TESTING_RAILS_41 = Gem::Dependency.new('rails', '~> 4.1.0') =~ Gem::Dependency.new('rails', Rails::VERSION::STRING)
TESTING_RAILS_42 = Gem::Dependency.new('rails', '~> 4.2.0') =~ Gem::Dependency.new('rails', Rails::VERSION::STRING)

ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Base.class_eval do
  connection.instance_eval do

    create_table :users, force: true do |t|
      t.string :name, :email
    end

    create_table :posts, id: false, force: true do |t|
      t.primary_key :id, :uuid, default: nil
      t.string :title, :body
      t.references :user
    end

    create_table :states, id: false, force: true do |t|
      t.primary_key :abbr, :string, default: nil
      t.string :name
    end

    create_table :enterprise_objects, id: :uuid, primary_key: :id, force: true do |t|
      t.string :name
    end unless TESTING_RAILS_40

  end
end

class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
end

class State < ActiveRecord::Base
  self.primary_key = :abbr
end

class EnterpriseObject < ActiveRecord::Base
  self.primary_key = :id
end
