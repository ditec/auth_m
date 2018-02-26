class AuthMCreateTables < ActiveRecord::Migration[5.1]
  def change

    ############################ create table managements ############################
    create_table :auth_m_managements do |t|
      t.string :name, null: false, unique: true, default: ""

      t.timestamps
    end


    ############################ create table resources ############################
    create_table :auth_m_resources do |t|
      t.string :name, null: false, unique: true
      t.references :management, null: false

      t.timestamps
    end
    add_index(:auth_m_resources, 'management_id', :name => 'index_managements_on_resources')


    ############################ create table people ############################
    create_table :auth_m_people do |t|
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :dni, unique: true
      t.references :management, null: false, default: 0

      t.timestamps
    end
    add_index(:auth_m_people, 'management_id', :name => 'index_managements_on_people')

    ############################ create table users ############################

    create_table :auth_m_users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      
      ## 
      t.integer :roles_mask, default: 2, null: false
      t.boolean :active, default: false, null: false
      t.references :person

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, polymorphic: true
      t.integer    :invitations_count, default: 0
      t.index      :invitations_count
      t.index      :invitation_token, unique: true # for invitable
      t.index      :invited_by_id

      t.string :confirmation_token, index: true
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      # t.string :unconfirmed_email # Only if using reconfirmable

      t.timestamps null: false
    end
    add_index(:auth_m_users, 'person_id', :name => 'index_peoples_on_users')
    add_index :auth_m_users, :email,                unique: true
    add_index :auth_m_users, :reset_password_token, unique: true
    # add_index :auth_m_users, :confirmation_token,   unique: true
    # add_index :auth_m_users, :unlock_token,         unique: true


    ############################ create table policies ############################
    create_table :auth_m_policies do |t|
      t.references :resource
      t.references :user
      t.string :access

      t.timestamps
    end
    add_index(:auth_m_policies, 'resource_id', :name => 'index_resources_on_policies')
    add_index(:auth_m_policies, 'user_id', :name => 'index_users_on_policies')

    ############################ create table linked accounts ############################
    create_table :auth_m_linked_accounts do |t|
      t.references :user, null: false
      t.string :provider, index: true, null: false
      t.string :uid, index: true, null: false

      t.timestamps
    end
    add_index(:auth_m_linked_accounts, 'user_id', :name => 'index_users_on_plinked_accounts')

  end
end
