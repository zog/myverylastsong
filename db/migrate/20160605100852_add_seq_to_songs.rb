class AddSeqToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :seq, :integer
  end
end
