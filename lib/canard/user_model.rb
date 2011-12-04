module Canard

  module UserModel
    
    def acts_as_user(*args)
      include RoleModel

      options = args.extract_options!.symbolize_keys

      roles options[:roles] if options.has_key?(:roles) && column_names.include?(roles_attribute_name.to_s)
              
        valid_roles.each do |role|
          define_scopes_for_role role
        end
    
    end
    
    private
    
    def define_scopes_for_role(role)
      
      attribute_name  = %{"#{table_name}"."#{roles_attribute_name}"}
      include_scope   = role.to_s.pluralize
      exclude_scope   = "non_#{include_scope}"

      (class << self; self end).class_eval do
        
        define_method(include_scope) do
          where("#{attribute_name} & :role_mask > 0", { :role_mask => mask_for(role) })
        end

        define_method(exclude_scope) do
          where("#{attribute_name} & :role_mask = 0 or #{attribute_name} is null", { :role_mask => mask_for(role) })
        end
        
      end

    end
      

  end

end