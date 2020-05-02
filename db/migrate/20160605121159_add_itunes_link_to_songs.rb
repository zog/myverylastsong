class AddItunesLinkToSongs < ActiveRecord::Migration[4.2]
  def change
    add_column :songs, :itunes_link, :string
  end
end
