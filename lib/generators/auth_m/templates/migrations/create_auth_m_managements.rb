class CreateAuthMManagements < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_m_managements do |t|
      t.string :name

      t.timestamps
    end
  end
end
