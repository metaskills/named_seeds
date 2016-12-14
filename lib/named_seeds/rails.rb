require 'active_support/concern'
require 'active_support/test_case'

module NamedSeeds
  module TestHelper

    extend ActiveSupport::Concern

    def after_teardown
      super
      NamedSeeds.reset_cache
    end

    module ClassMethods

      def named_seeds(*names)
        options = names.extract_options!
        if names.many?
          names.each do |name|
            define_method(name) do |*identities|
              Identity.named(name).find(*identities)
            end
          end
        else
          name = names.first
          define_method(name) do |*identities|
            Identity.named(name, options).find(*identities)
          end
        end
      end

    end

  end
end

ActiveSupport::TestCase.send :include, NamedSeeds::TestHelper
