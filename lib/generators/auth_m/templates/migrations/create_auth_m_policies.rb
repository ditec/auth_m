class CreateAuthMPolicies < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_m_policies do |t|
      t.references :resource
      t.references :user
      t.string :access

      t.timestamps
    end
    add_index(:auth_m_policies, 'resource_id', :name => 'index_resources_on_policies')
    add_index(:auth_m_policies, 'user_id', :name => 'index_users_on_policies')

  end
end
