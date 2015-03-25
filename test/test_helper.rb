require 'rubygems'
require 'bundler' ; Bundler.require :development, :test
require 'named_seeds'
require 'support/active_record'
require 'active_support/test_case'
require 'active_support/testing/autorun'

ActiveSupport.test_order = :random if ActiveSupport.respond_to?(:test_order)

module NamedSeeds
  class TestCase < ActiveSupport::TestCase

    class << self

      def id(*args)
        NamedSeeds.identify(*args)
      end

      def create_user(id, attributes={})
        ::User.create!(attributes) { |x| x.id = id }
      end

      def create_state(id, attributes={})
        ::State.create!(attributes) { |x| x.abbr = id }
      end

      def create_enterprise_object(id, attributes={})
        ::EnterpriseObject.create!(attributes) { |x| x.id = id }
      end

    end

    @@ken  = create_user 155397742, name: 'Ken Collins', email: 'ken@metaskills.net'
    @@john = create_user 830138774, name: 'John Hall', email: 'john.hall@example.com'

    @@virginia   = create_state 'VA', name: 'Virginia'
    @@washington = create_state 'WA', name: 'Washington'

    @@enterprising_ken = create_enterprise_object '4f156606-8cb3-509e-a177-956ca0a22015', name: 'Ken Collins' unless TESTING_RAILS_40


    private

    def id(*args) ; self.class.id(*args) ; end

  end
end
