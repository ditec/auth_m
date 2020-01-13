class AuthMCreateTables < ActiveRecord::Migration[5.1]
  def change

    ############################ create table managements ############################
    create_table :auth_m_managements do |t|
      t.string :name, null: false, unique: true

      t.timestamps
    end

    ############################ create table management_resources ############################
    create_table :auth_m_management_resources do |t|
      t.string :name, null: false
      t.references :management, null: false, index: true

      t.timestamps
    end

    ############################ create table branches ############################
    create_table :auth_m_branches do |t|
      t.string :name, null: false
      t.references :management, index: true

      t.timestamps
    end

    ############################ create table branch_resources ############################
    create_table :auth_m_branch_resources do |t|
      t.references :management_resource, null: false, index: true
      t.references :branch, null: false, index: true

      t.timestamps
    end

    ############################ create table users ############################
    create_table :auth_m_users do |t|
      ## Database authenticatable
      t.string :username,           null: false, unique: true
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      
      ## 
      t.integer :roles_mask, null: false
      t.boolean :active, default: true
      t.references :management, index: true

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
      t.string :confirmation_token, index: true
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Invitable
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

      ## Password expirable
      # t.datetime :password_changed_at

      ## Session limitable
      t.string :unique_session_id

      ## Expirable
      t.datetime :last_activity_at
      t.datetime :expired_at

      ## Paranoid verifiable
      # t.string   :paranoid_verification_code
      # t.integer  :paranoid_verification_attempt, default: 0
      # t.datetime :paranoid_verified_at


      t.timestamps null: false
    end
    add_index :auth_m_users, :email,                unique: true
    add_index :auth_m_users, :reset_password_token, unique: true
    add_index :auth_m_users, :last_activity_at
    add_index :auth_m_users, :expired_at
    # add_index :auth_m_users, :confirmation_token,   unique: true
    # add_index :auth_m_users, :unlock_token,         unique: true
    # add_index :auth_m_users, :password_changed_at
    # add_index :auth_m_users, :paranoid_verification_code
    # add_index :auth_m_users, :paranoid_verified_at

    AuthM::User.create(email:"root@a.com", 
                       username: "root", 
                       password:"Asd12345", 
                       password_confirmation:"Asd12345", 
                       roles: [:root], 
                       active: true, 
                       confirmed_at: DateTime.now.to_date).save(validate: false)

    ############################ create table policy groups ############################
    create_table :auth_m_policy_groups do |t|
      t.string :name, null: false
      t.references :branch, index: true, null: false
      t.boolean :customized, default: false

      t.timestamps
    end

    ############################ create table users_policy_groups ############################
    create_table :auth_m_policy_groups_users, id: false do |t|
      t.belongs_to :user, null: false
      t.belongs_to :policy_group, null: false
    end
    add_index :auth_m_policy_groups_users, [:user_id, :policy_group_id]

    ############################ create table policies ############################
    create_table :auth_m_policies do |t|
      t.references :policy_group, index: true
      t.references :branch_resource, index: true
      t.string :access

      t.timestamps
    end

    ############################ create table linked accounts ############################
    create_table :auth_m_linked_accounts do |t|
      t.references :user, null: false, index: true
      t.string :provider, index: true, null: false
      t.string :uid, index: true, null: false

      t.timestamps
    end

  end
end