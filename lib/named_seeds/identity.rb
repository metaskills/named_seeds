require 'active_record/fixtures'

module NamedSeeds

  class FixtureClassNotFound < ActiveRecord::FixtureClassNotFound
  end

  class Identity

    @@all_cached = Hash.new

    class << self

      def reset_cache
        @@all_cached.clear
      end

      def named(name, options={})
        @@all_cached[name] ||= new(name, options)
      end

    end

    def initialize(name, options={})
      @name = name
      @options = options
      @fixtures = {}
    end

    def find(*identities)
      fixtures = identities.map { |identity| model_find(identity) }
      fixtures.many? ? fixtures : fixtures.first
    end

    def identities
      @options[:identities] || @options[:ids]
    end


    private

    def model_find(identity)
      @fixtures[identity.to_s] ||= model_class.unscoped { model_class.find model_id(identity) }
    end

    def model_class
      return @model_class if defined?(@model_class)
      @model_class = (@options[:class] || @options[:klass]) || @name.to_s.classify.safe_constantize
      raise FixtureClassNotFound, "No class found for named_seed #{@name.inspect}. Use :class option." unless @model_class
      @model_class
    end

    def model_id(identity)
      case identities
      when NilClass then NamedSeeds.identify(identity, model_primary_key_type)
      when Hash     then identities[identity]
      when :natural then identity
      end
    end

    def model_primary_key_type
      type     = model_class.columns_hash[model_class.primary_key].type
      sql_type = model_class.columns_hash[model_class.primary_key].sql_type
      return :uuid if ['uuid', 'guid', 'uniqueidentifier'].include?(sql_type)
      type ? type.to_sym : :id
    end

  end

end
