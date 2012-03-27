module NamedSeeds
  class Railtie < Rails::Railtie
    
    config.named_seeds = ActiveSupport::OrderedOptions.new
    config.named_seeds.app_load_seed          = false
    config.named_seeds.engines_with_load_seed = []
    
    config.named_seeds.db_cleaner = ActiveSupport::OrderedOptions.new
    config.named_seeds.db_cleaner.orm           = :active_record
    config.named_seeds.db_cleaner.connection    = :test
    config.named_seeds.db_cleaner.strategy      = :truncation
    config.named_seeds.db_cleaner.strategy_args = {}

    config.before_initialize do |app|
      Rails.application.paths.add 'db/test/seeds', :with => 'db/test/seeds.rb'
    end

    rake_tasks do
      load "named_seeds/railties/databases.rake"
    end
    
    def load_seed
      setup_test_environment
      clean_test_database
      load_all_seeds
    end
    
    
    protected
    
    def setup_test_environment
      unless Rails.env.test?
        ActiveRecord::Base.clear_all_connections!
        ActiveRecord::Base.configurations.clear
        silence_warnings { Object.const_set :RAILS_ENV, 'test' ; ENV['RAILS_ENV'] = 'test' ; Rails.instance_variable_set :@_env, nil }
        ActiveRecord::Base.configurations = Rails.configuration.database_configuration
        ActiveRecord::Base.establish_connection
      end
    end
    
    def clean_test_database
      require 'database_cleaner'
      DatabaseCleaner.logger = Rails.logger
      cleaner_opts = config.named_seeds.db_cleaner
      cleaner = DatabaseCleaner[cleaner_opts.orm, {:connection => cleaner_opts.connection}]
      cleaner.clean_with cleaner_opts.strategy, cleaner_opts.strategy_args
    end
    
    def load_all_seeds
      Rails.application.load_seed if config.named_seeds.app_load_seed
      config.named_seeds.engines_with_load_seed.each { |engine| engine.load_seed }
      seed_file = Rails.application.paths["db/test/seeds"].existent.first
      load(seed_file) if seed_file
    end
    
  end
end
