class CreateAuthMResources < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_m_resources do |t|
      t.string :name
      t.references :management

      t.timestamps
    end
    add_index(:auth_m_resources, 'management_id', :name => 'index_managements_on_resources')
  end
end
