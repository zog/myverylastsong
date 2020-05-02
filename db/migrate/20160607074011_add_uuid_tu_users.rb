class AddUuidTuUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :uuid, :string
    add_index :users, :uuid
  end
end
