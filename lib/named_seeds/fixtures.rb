require 'zlib'
require 'active_support/concern'

module NamedSeeds
  
  # A direct copy of ActiveRecord::Fixtures.identify.
  # Returns a consistent, platform-independent identifier for +label+ that are positive integers less than 2^32.
  def self.identify(label)
    Zlib.crc32(label.to_s) % (2 ** 30 - 1)
  end
  
  module Fixtures
    
    extend ActiveSupport::Concern
    
    module ClassMethods

      def named_seeds(name, options = {})
        klass = options[:klass] || name.to_s.classify.constantize
        identities = options[:identities]
        case identities
        when Hash
          define_method(name) do |*fixnames|
            objs = fixnames.map do |fixname|
              id = identities[fixname.to_sym]
              find_named_seed name, klass, id, fixname
            end
            fixnames.one? ? objs.first : objs
          end
        else
          define_method(name) do |*fixnames|
            objs = fixnames.map do |fixname|
              id = NamedSeeds.identify(fixname)
              find_named_seed name, klass, id, fixname
            end
            fixnames.one? ? objs.first : objs
          end
        end
      end
        
    end

    protected
    
    def find_named_seed(name, klass, id, fixname)
      begin
        klass.find(id)
      rescue ActiveRecord::RecordNotFound => e
        nsfinder = :"#{name}_#{fixname}"
        raise e unless respond_to?(nsfinder)
        send(nsfinder)
      end
    end
    
  
  end
end

