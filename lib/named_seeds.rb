require 'rails'
require 'active_record'
require 'named_seeds/version'
require 'named_seeds/railtie'
require 'named_seeds/uuid'
require 'named_seeds/dsl'
require 'named_seeds/identity'
require 'named_seeds/rails'

module NamedSeeds

  extend DSL

  def self.load_seed
    Railtie.load_seed
  end

  def self.reset_cache
    Identity.reset_cache
  end

end
