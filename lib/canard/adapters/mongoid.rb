module Canard
  module Adapters
    module Mongoid

      private

      def add_role_scopes
        valid_roles.each do |role|
          define_scopes_for_role role
        end

        def with_any_role(*roles)
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) > 0")
        end

        def with_all_roles(*roles)
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) === #{mask_for(*roles)}")
        end

        def with_only_roles(*roles)
          where("this.#{roles_attribute_name} === #{mask_for(*roles)}")
        end
      end

      def has_roles_mask_accessors?
       fields.include?(roles_attribute_name.to_s) || super
      end

      def define_scopes_for_role(role)
        include_scope   = role.to_s.pluralize
        exclude_scope   = "non_#{include_scope}"
        
        scope include_scope, lambda { where("(this.#{roles_attribute_name} & #{mask_for(role)}) > 0") }
        scope exclude_scope, lambda { any_of({roles_attribute_name  => { "$exists" => false }}, {roles_attribute_name => nil}, {"$where" => "(this.#{roles_attribute_name} & #{mask_for(role)}) === 0"}) }
      end

    end
  end
end

Mongoid::Document::ClassMethods.send :include, Canard::Adapters::Mongoid
Mongoid::Document::ClassMethods.send :include, Canard::UserModel
Canard.find_abilities