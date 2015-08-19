module Canard
  module UserModel

    # Canard applies roles to a model using the acts_as_user class method. The following User model
    # will be given the :manager and :admin roles
    #
    #   class User < ActiveRecord::Base
    #
    #     acts_as_user :roles => [:manager, :admin]
    #
    #   end
    #
    # If using Canard with a non ActiveRecord class you can still assign roles but you will need to
    # extend the class with Canard::UserModel and add a roles_mask attribute.
    #
    #   class User
    #
    #     extend Canard::UserModel
    #
    #     attr_accessor :roles_mask
    #
    #     acts_as_user :roles => [:manager, :admin]
    #
    #   end
    #
    # You can choose the attribute used for the roles_mask by specifying :roles_mask. If no
    # roles_mask is specified it uses RoleModel's default of 'roles_mask'
    #
    #    acts_as_user :roles_mask => :my_roles_mask, :roles => [:manager, :admin]
    #
    # == Scopes
    #
    # Beyond applying the roles to the model, acts_as_user also creates some useful scopes for
    # ActiveRecord models;
    #
    #   User.with_any_role(:manager, :admin)
    #
    # returns all the managers and admins
    #
    #  User.with_all_roles(:manager, :admin)
    #
    # returns only the users with both the manager and admin roles
    #
    #   User.admins
    #
    # returns all the admins as
    #
    #  User.managers
    #
    # returns all the users with the maager role likewise
    #
    #   User.non_admins
    #
    # returns all the users who don't have the admin role and
    #
    #   User.non_managers
    #
    # returns all the users who don't have the manager role.
    def acts_as_user(*args)
      include RoleModel
      include InstanceMethods
      
      options = args.last.is_a?(Hash) ? args.pop : {}
      
      if defined?(ActiveRecord) && self < ActiveRecord::Base
        extend Adapters::ActiveRecord
      elsif defined?(Mongoid) && self.included_modules.include?(Mongoid::Document)
        extend Adapters::Mongoid
        field (options[:roles_mask] || :roles_mask), :type => Integer
      end

      roles_attribute options[:roles_mask] if options.has_key?(:roles_mask)

      roles options[:roles] if options.has_key?(:roles) && has_roles_mask_accessors?

      add_role_scopes(prefix: options[:prefix]) if respond_to?(:add_role_scopes, true)
    end

    private

    # This is overridden by the ActiveRecord adapter as the attribute accessors
    # don't show up in instance_methods.
    def has_roles_mask_accessors?
      instance_method_names = instance_methods.map { |method_name| method_name.to_s }
      [roles_attribute_name.to_s, "#{roles_attribute_name}="].all? do |accessor| 
        instance_method_names.include?(accessor)
      end
    end

    module InstanceMethods

      def ability
        @ability ||= Ability.new(self)
      end

    end
  end
end
