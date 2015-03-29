namespace :named_seeds do

  task :setup => :environment do
    NamedSeeds::Railtie.db_setup
  end

end

Rake::Task['db:setup'].enhance { Rake::Task['named_seeds:setup'].invoke }
