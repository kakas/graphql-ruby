# frozen_string_literal: true
module GraphQL
  class Schema
    class Interface < GraphQL::Schema::Member
      Field = GraphQL::Schema::Field
      class << self
        include GraphQL::Schema::Member::HasFields

        # Inherited methods go here
        def implemented(&block)
          @implemented_hook = block
        end

        def apply_implemented(object_class)
          if superclass < GraphQL::Schema::Interface
            superclass.apply_implemented(object_class)
          end
          @implemented_hook && object_class.class_exec(&@implemented_hook)
        end

        def to_graphql
          type_defn = GraphQL::InterfaceType.new
          type_defn.name = graphql_name
          type_defn.description = description
          fields.each do |field_inst|
            field_defn = field_inst.graphql_definition
            type_defn.fields[field_defn.name] = field_defn
          end
          type_defn
        end
      end
    end
  end
end
