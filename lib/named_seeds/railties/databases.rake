namespace :db do  
  namespace :test do
    
    desc "Run the seed data from db/test/seeds.rb"
    task :seed => :environment do
      Rake::Task["db:abort_if_pending_migrations"].invoke
      NamedSeeds::Railtie.load_seed
    end

  end
end

task 'test:prepare' => 'db:test:seed'
