require 'active_record/tasks/database_tasks'

module NamedSeeds
  class Railtie < Rails::Railtie

    config.named_seeds = ActiveSupport::OrderedOptions.new
    config.named_seeds.load_app_seed_file     = true
    config.named_seeds.custom_seed_file       = nil
    config.named_seeds.engines_with_load_seed = []

    config.before_initialize do |app|
      ActiveRecord::Tasks::DatabaseTasks.seed_loader = NamedSeeds::Railtie
    end

    rake_tasks do
      load 'named_seeds/databases.rake'
    end

    def load_seed
      load_app_seed_file
      load_custom_seed_file
      engines_load_seed
    end

    def db_setup
      load_custom_seed_file
      engines_load_seed
    end


    protected

    def load_app_seed_file
      Rails.application.load_seed if config.named_seeds.load_app_seed_file
    end

    def load_custom_seed_file
      return unless config.named_seeds.custom_seed_file
      custom_seed_file = Rails.root.join(config.named_seeds.custom_seed_file)
      load(custom_seed_file) if File.exists?(custom_seed_file)
    end

    def engines_load_seed
      config.named_seeds.engines_with_load_seed.each { |engine| engine.load_seed }
    end

  end
end
