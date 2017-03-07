module Canard
  module Adapters
    module ActiveRecord

      private

      def add_role_scopes(*args)
        options = args.extract_options!
        # TODO change to check has_roles_attribute?
        if active_record_table?
          valid_roles.each do |role|
            define_scopes_for_role role, options[:prefix]
          end

          # TODO change hard coded :role_mask to roles_attribute_name
          define_singleton_method(:with_any_role) do |*roles|
            where("#{role_mask_column} & :role_mask > 0", { :role_mask => mask_for(*roles) })
          end

          define_singleton_method(:with_all_roles) do |*roles|
            where("#{role_mask_column} & :role_mask = :role_mask", { :role_mask => mask_for(*roles) })
          end

          define_singleton_method(:with_only_roles) do |*roles|
            where("#{role_mask_column} = :role_mask", { :role_mask => mask_for(*roles) })
          end
        end
      end

      def active_record_table?
        respond_to?(:table_exists?) && table_exists?
      end

      # TODO extract has_roles_attribute? and change to has_roles_attribute? || super
      def has_roles_mask_accessors?
        active_record_table? && column_names.include?(roles_attribute_name.to_s) || super
      end

      def define_scopes_for_role(role, prefix=nil)
        include_scope = [prefix, String(role).pluralize].compact.join('_')
        exclude_scope = "non_#{include_scope}"

        define_singleton_method(include_scope) do
          where("#{role_mask_column} & :role_mask > 0", { :role_mask => mask_for(role) })
        end

        define_singleton_method(exclude_scope) do
          where("#{role_mask_column} & :role_mask = 0 or #{role_mask_column} is null", { :role_mask => mask_for(role) })
        end
      end

      def role_mask_column
        "#{quoted_table_name}.#{connection.quote_column_name roles_attribute_name}"
      end
    end
  end
end