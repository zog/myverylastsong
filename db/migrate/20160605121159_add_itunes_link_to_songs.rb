class AddItunesLinkToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :itunes_link, :string
  end
end
