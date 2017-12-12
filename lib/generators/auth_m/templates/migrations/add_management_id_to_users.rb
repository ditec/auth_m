class AddManagementIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :auth_m_users, :management

    add_index(:auth_m_users, 'management_id', :name => 'index_managements_on_users')
  end

end
