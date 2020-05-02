class AddSeqToSongs < ActiveRecord::Migration[4.2]
  def change
    add_column :songs, :seq, :integer
  end
end
