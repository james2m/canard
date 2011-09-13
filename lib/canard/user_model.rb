module Canard

  module UserModel
    
    def acts_as_user(*args)
      options = args.extract_options!.symbolize_keys

      include UserInstanceMethods
      include RoleModel

      class_eval do
        has_one   :account, :dependent => :destroy, :as => 'user'
        delegate  :email,   :to => :account, :allow_nil => true
      end

      roles options[:roles] if options.has_key?(:roles) && self.column_names.include?(self.roles_attribute_name.to_s)
    end

  end

  module UserInstanceMethods

    def name
      "#{self.first_name} #{self.last_name}".strip
    end

  end

end