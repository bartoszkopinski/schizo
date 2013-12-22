require "schizo/facade/fetcher"

module Schizo
  module Facade #:nodoc:

    def self.fetch(base_class, roles)
      Fetcher.new(base_class, roles).call
    end

    def self.included(mod)
      mod.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :schizo

      def name
        if schizo.nil?
          "Schizo::Facade(0x%014x)" % object_id
        else
          schizo.name
        end
      end

      def to_s
        name
      end

      def inspect
        if defined?(Mongoid::Document) and ancestors.include?(Mongoid::Document)
          # Copy pasta from ActiveRecord
          if abstract_class?
            "#{name}(abstract)"
          elsif table_exists?
            attr_list = columns.map { |c| "#{c.name}: #{c.type}" } * ', '
            "#{name}(#{attr_list})"
          else
            "#{name}(Table doesn't exist)"
          end
        else
          name
        end
      end

    end

    def initialize(object)
      object.instance_variables.each do |name|
        instance_variable_set(name, object.instance_variable_get(name))
      end
    end

    def schizo
      self.class.schizo
    end

    def inspect
      if defined?(Mongoid::Document) and kind_of?(Mongoid::Document)
        super
      else
        to_s
      end
    end

    def to_s
      "#<#{self.class.name}:0x%014x>" % object_id
    end

  end
end
