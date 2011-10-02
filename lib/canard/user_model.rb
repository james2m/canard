module Canard

  module UserModel
    
    def acts_as_user(*args)
      include RoleModel

      options = args.extract_options!.symbolize_keys

      roles options[:roles] if options.has_key?(:roles) && column_names.include?(roles_attribute_name.to_s)
    end

  end

end