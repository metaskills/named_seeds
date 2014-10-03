module NamedSeeds
  class Railtie < Rails::Railtie

    config.named_seeds = ActiveSupport::OrderedOptions.new
    config.named_seeds.app_load_seed          = true
    config.named_seeds.engines_with_load_seed = []

    config.before_initialize do |app|
      Rails.application.paths.add 'db/test/seeds', with: 'db/test/seeds.rb'
    end

    rake_tasks do
      load "named_seeds/railties/databases.rake"
    end

    def setup
      load test_seed_file if test_seed_file
    end

    def prepare
      return unless test_seed_file
      load_all_seeds
      setup
    end


    protected

    def load_all_seeds
      ActiveRecord::Tasks::DatabaseTasks.load_seed if config.named_seeds.app_load_seed
      config.named_seeds.engines_with_load_seed.each { |engine| engine.load_seed }
    end

    def test_seed_file
      Rails.application.paths["db/test/seeds"].existent.first
    end

  end

  def self.prepare
    NamedSeeds::Railtie.prepare
  end

end
