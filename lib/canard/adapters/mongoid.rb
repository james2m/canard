module Canard
  module Adapters
    module Mongoid

      private

      def add_role_scopes
        valid_roles.each do |role|
          define_scopes_for_role role
        end

        define_scope_method(:with_any_role) do |*roles|
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) > 0")
        end

        define_scope_method(:with_all_roles) do |*roles|
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) === #{mask_for(*roles)}")
        end

        define_scope_method(:with_only_roles) do |*roles|
          where("this.#{roles_attribute_name} === #{mask_for(*roles)}")
        end
      end

      def has_roles_mask_accessors?
       fields.include?(roles_attribute_name.to_s) || super
      end

      def define_scopes_for_role(role)
        include_scope   = role.to_s.pluralize
        exclude_scope   = "non_#{include_scope}"

        define_scope_method(include_scope) do
          where("(this.#{roles_attribute_name} & #{mask_for(role)}) > 0")
        end

        define_scope_method(exclude_scope) do
          any_of({roles_attribute_name  => { "$exists" => false }}, {roles_attribute_name => nil}, {"$where" => "(this.#{roles_attribute_name} & #{mask_for(role)}) === 0"})
        end
      end

      def define_scope_method(method, &block)
        (class << self; self end).class_eval do
          define_method(method, block)
        end
      end

    end
  end
end

Mongoid::Document::ClassMethods.send :include, Canard::Adapters::Mongoid
Mongoid::Document::ClassMethods.send :include, Canard::UserModel
Canard.find_abilities