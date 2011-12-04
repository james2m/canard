module Canard

  module UserModel
    
    def acts_as_user(*args)
      include RoleModel

      options = args.extract_options!.symbolize_keys

      roles options[:roles] if options.has_key?(:roles) && column_names.include?(roles_attribute_name.to_s)
              
      valid_roles.each do |role|
        define_scopes_for_role role
      end
    
      define_scope_method(:with_any_role) do |*roles|
        where("#{role_mask_column} & :role_mask > 0", { :role_mask => mask_for(*roles) })
      end
    
      define_scope_method(:with_all_roles) do |*roles|
        where("#{role_mask_column} & :role_mask = :role_mask", { :role_mask => mask_for(*roles) })
      end
    end
    
    private
    
    def define_scopes_for_role(role)
      include_scope   = role.to_s.pluralize
      exclude_scope   = "non_#{include_scope}"

      define_scope_method(include_scope) do
        where("#{role_mask_column} & :role_mask > 0", { :role_mask => mask_for(role) })
      end

      define_scope_method(exclude_scope) do
        where("#{role_mask_column} & :role_mask = 0 or #{role_mask_column} is null", { :role_mask => mask_for(role) })
      end
    end
    
    def define_scope_method(method, &block)
      (class << self; self end).class_eval do
        define_method(method, block)
      end
    end
    
    def role_mask_column
      %{"#{table_name}"."#{roles_attribute_name}"}
    end

  end

end