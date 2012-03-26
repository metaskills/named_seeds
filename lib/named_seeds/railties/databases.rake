namespace :db do  
  namespace :test do
    
    desc "Run the seed data from db/test/seeds.rb"
    task :seed => :environment do
      Rake::Task["db:abort_if_pending_migrations"].invoke
      Rake::Task["db:test:_setup_test_environment_for_named_seeds"].invoke
      NamedSeeds::Railtie.load_seed
    end

    task :_setup_test_environment_for_named_seeds do
      # unless Rails.env.test?
        ActiveRecord::Base.clear_all_connections!
        ActiveRecord::Base.configurations.clear
        silence_warnings { Object.const_set :RAILS_ENV, 'test' ; ENV['RAILS_ENV'] = 'test' ; Rails.instance_variable_set :@_env, nil }
        ActiveRecord::Base.configurations = Rails.configuration.database_configuration
        ActiveRecord::Base.establish_connection
      # end
    end

  end
end

task 'db:test:prepare' => 'db:test:seed'
