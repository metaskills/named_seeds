namespace :named_seeds do

  task :setup => :environment do
    NamedSeeds::Railtie.setup
  end

  task :prepare do
    NamedSeeds::Railtie.prepare
  end

end

Rake::Task['db:setup'].enhance { Rake::Task['named_seeds:setup'].invoke }
Rake::Task['db:test:prepare'].enhance { Rake::Task['named_seeds:prepare'].invoke }
