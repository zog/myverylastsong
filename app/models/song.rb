require "open-uri"

class Song < ActiveRecord::Base

  belongs_to :user, primary_key: :uuid

  after_commit do
    user.save_playlist
  end

  def self.top limit=3
    group(:spotify_id).limit(limit).count.keys.map{|k| Song.where(spotify_id: k).last}
  end

  def to_front
    out = attributes.dup
    out["id"] = out.delete("spotify_id")
    out
  end

  def artist_name
    if artists.size > 0
      artists.first["name"]
    end
  end

  def full_name
    [artist_name, name].compact.join(' - ')
  end

  def spotify_uri
    "spotify:track:#{spotify_id}"
  end

  def fetch_itunes_link
    other = Song.where(spotify_id: self.spotify_id).where("itunes_link != ?", "not_found").where('itunes_link IS NOT NULL').last
    if other
      link = other.itunes_link
    else
      url = "https://itunes.apple.com/search?term=#{URI.encode self.full_name}&media=music"
      data = JSON.parse open(url).read
      res = data["results"]
      if res.size > 0
        link = res[0]["collectionViewUrl"]
      else
        link = "not_found"
      end
    end
    update_attribute :itunes_link, link
  end

  def valid_itunes_link?
    itunes_link.present? && itunes_link != "not_found"
  end
end
