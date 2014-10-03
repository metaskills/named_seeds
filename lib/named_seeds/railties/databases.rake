namespace :named_seeds do

  task :setup => :environment do
    NamedSeeds::Railtie.setup
  end

  task :prepare do
    NamedSeeds::Railtie.prepare
  end

end

task 'db:setup' => 'named_seeds:setup'
