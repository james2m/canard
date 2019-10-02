# frozen_string_literal: true

module Canard
  module Adapters
    module Mongoid # :nodoc:
      private

      def add_role_scopes(*args)
        options = args.extract_options!
        valid_roles.each do |role|
          define_scopes_for_role role, options[:prefix]
        end

        define_singleton_method(:with_any_role) do |*roles|
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) > 0")
        end

        define_singleton_method(:with_all_roles) do |*roles|
          where("(this.#{roles_attribute_name} & #{mask_for(*roles)}) === #{mask_for(*roles)}")
        end

        define_singleton_method(:with_only_roles) do |*roles|
          where("this.#{roles_attribute_name} === #{mask_for(*roles)}")
        end
      end

      def has_roles_mask_accessors?
        fields.include?(roles_attribute_name.to_s) || super
      end

      def define_scopes_for_role(role, prefix = nil)
        include_scope = [prefix, String(role).pluralize].compact.join('_')
        exclude_scope = "non_#{include_scope}"

        scope include_scope, -> { where("(this.#{roles_attribute_name} & #{mask_for(role)}) > 0") }
        scope exclude_scope, lambda {
          any_of(
            { roles_attribute_name => { '$exists' => false } },
            { roles_attribute_name => nil },
            '$where' => "(this.#{roles_attribute_name} & #{mask_for(role)}) === 0"
          )
        }
      end
    end
  end
end

Mongoid::Document::ClassMethods.send(:include, Canard::Adapters::Mongoid)
Mongoid::Document::ClassMethods.send(:include, Canard::UserModel)
Canard.find_abilities
