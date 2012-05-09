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
    # == Scopes
    #
    # Beyond applying the roles to model acts_as_user also creates some useful scopes on the User
    # model;
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
      if table_exists?
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
