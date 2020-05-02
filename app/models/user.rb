class User < ActiveRecord::Base
  has_many :songs, primary_key: :uuid

  before_save do
    unless read_attribute :uuid
      write_attribute :uuid, SecureRandom.hex(6)
    end
  end

  def name
    "#{first_name.try :capitalize} #{last_name.try :upcase}"
  end

  def pronoun
    gender.present? ? (gender == "male" ? 'his' : 'her') : 'their'
  end

  def save_playlist
    create_playlist

    SpotifyToken.mvls_user

    playlist = RSpotify::Playlist.find_by_id(playlist_id)
    snapshot_id = playlist.snapshot_id
    positions = (0...playlist.tracks.size).to_a
    playlist.remove_tracks! positions, snapshot_id: snapshot_id

    return unless songs.any?

    playlist.add_tracks! songs.order(:seq).map(&:spotify_uri)
  end

  def playlist_name
    name.presence || uuid
  end

  def create_playlist
    return if playlist_id.present?

    playlist = SpotifyToken.mvls_user.create_playlist!(playlist_name)
    update playlist_id: playlist.id
  end
end
