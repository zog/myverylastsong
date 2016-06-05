require "open-uri"

class Song < ActiveRecord::Base
  def to_front
    out = attributes.dup
    out["id"] = out.delete("spotify_id")
    out
  end

  def fetch_itunes_link
    url = "https://itunes.apple.com/search?term=#{URI.encode self.name}&media=music"
    data = JSON.parse open(url).read
    res = data["results"]
    if res.size > 0
      update_attribute :itunes_link, res[0]["collectionViewUrl"]
    else
      update_attribute :itunes_link, "not_found"
    end
  end

  def valid_itunes_link?
    itunes_link.present? && itunes_link != "not_found"
  end
end
