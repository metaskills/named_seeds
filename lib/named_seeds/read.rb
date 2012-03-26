require 'active_support/concern'

module NamedSeeds
  module Read
    
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

