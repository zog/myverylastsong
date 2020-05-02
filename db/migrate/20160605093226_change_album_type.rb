class ChangeAlbumType < ActiveRecord::Migration[4.2]
  def change

    rename_column :songs, :album, :album_old
    add_column :songs, :album, :json
    Song.connection.schema_cache.clear!
    Song.reset_column_information
    Song.all.each do |s|
      s.album = eval s.album_old
      s.save
    end
    remove_column :songs, :album_old
  end
end
