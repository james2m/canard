module Canard
  module UserModel

    # Canard applies roles to a model using the acts_as_user class method. The following User model
    # will be given the :manager and :admin roles
    #
    #   class User < ActiveRecord::Base
    #
    #     acts_as_user :roles =>  :manager, :admin
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
    #     acts_as_user :roles =>  :manager, :admin
    #
    #   end
    #
    # == Scopes
    #
    # Beyond applying the roles to model acts_as_user also creates some useful scopes on the User
    # model for ActiveRecord models;
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
      extend Adapters::ActiveRecord if defined?(ActiveRecord) && self < ActiveRecord::Base

      options = args.extract_options!.symbolize_keys

      roles options[:roles] if options.has_key?(:roles) && has_roles_mask_accessors?

      add_role_scopes if respond_to?(:add_role_scopes, true)
    end

    private

    def has_roles_mask_accessors?
      instance_method_names = instance_methods.map { |method_name| method_name.to_s }
      [roles_attribute_name.to_s, "#{roles_attribute_name}="].all? do |accessor| 
        instance_method_names.include?(accessor)
      end
    end
  end
end
