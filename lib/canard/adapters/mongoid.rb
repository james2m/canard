module Canard
  module Adapters
    module Mongoid

      private

      def add_role_scopes
        valid_roles.each do |role|
          define_scopes_for_role role
        end

        scope :with_any_role, ->(*roles) do
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) > 0")
        end

        scope :with_all_roles, ->(*roles) do
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) === #{mask_for(*roles)}")
        end

        scope :with_only_roles, ->(*roles) do
          where("this.#{roles_attribute_name} === #{mask_for(*roles)}")
        end
      end

      def has_roles_mask_accessors?
       fields.include?(roles_attribute_name.to_s) || super
      end

      def define_scopes_for_role(role)
        include_scope   = role.to_s.pluralize
        exclude_scope   = "non_#{include_scope}"
        
        scope include_scope, where("(this.#{roles_attribute_name} & #{mask_for(role)}) > 0")
        scope exclude_scope, any_of({roles_attribute_name  => { "$exists" => false }}, {roles_attribute_name => nil}, {"$where" => "(this.#{roles_attribute_name} & #{mask_for(role)}) === 0"})
      end

    end
  end
end

Mongoid::Document::ClassMethods.send :include, Canard::Adapters::Mongoid
Mongoid::Document::ClassMethods.send :include, Canard::UserModel
Canard.find_abilities