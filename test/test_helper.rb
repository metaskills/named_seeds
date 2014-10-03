require 'rubygems'
require "bundler/setup"
Bundler.require
require 'named_seeds'
require 'minitest/autorun'
require 'support/active_record'

ActiveSupport.test_order = :random

module NamedSeeds
  class Spec < MiniTest::Spec


  end
end
