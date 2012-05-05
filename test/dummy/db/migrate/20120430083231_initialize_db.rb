class InitializeDb < ActiveRecord::Migration
  
  def change
    create_table :users, :force => true do |t|
      t.integer     :roles_mask
    end
    create_table :user_without_roles, :force => true do |t|
      t.integer     :roles_mask
    end
    create_table :user_without_role_masks, :force => true do |t|
    end
  
    create_table :members, :force => true do |t|
      t.references :user
    end
  end
  
end
