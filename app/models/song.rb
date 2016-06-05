class Song < ActiveRecord::Base
  def to_front
    out = attributes.dup
    out["id"] = out.delete("spotify_id")
    out
  end
end
