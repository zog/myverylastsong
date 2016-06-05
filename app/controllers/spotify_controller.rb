class SpotifyController < ApplicationController
  def search
    res = RSpotify::Track.search(URI.decode(params[:q]))[0..10]
    render json: res.map{|r| {
      name: r.name,
      artists: r.artists,
      album: r.album,
      id: r.id,
    }}
  end
end
