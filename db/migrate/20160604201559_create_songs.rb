class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :user_id
      t.string :name
      t.string :spotify_id
      t.json :artists
      t.string :album

      t.timestamps null: false
    end
  end
end
