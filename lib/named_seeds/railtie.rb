require 'active_record/tasks/database_tasks'

module NamedSeeds
  class Railtie < Rails::Railtie

    config.named_seeds = ActiveSupport::OrderedOptions.new
    config.named_seeds.engines_with_load_seed = []

    config.before_initialize do |app|
      ActiveRecord::Tasks::DatabaseTasks.seed_loader = NamedSeeds::Railtie
    end

    def load_seed
      Rails.application.load_seed
      engines_load_seed
    end


    protected

    def engines_load_seed
      config.named_seeds.engines_with_load_seed.each { |engine| engine.load_seed }
    end

  end
end
