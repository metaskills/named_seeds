require 'rubygems'
require "bundler/setup"
Bundler.require
require 'named_seeds'
require 'active_record/base'
require 'minitest/autorun'

ActiveRecord::Base.logger = nil
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

require 'support/schema'

module NamedSeeds
  class Spec < MiniTest::Spec
    
    
  end
end
