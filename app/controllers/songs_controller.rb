class SongsController < ApplicationController
  def index
    respond_to do |f|
      f.html
      f.json do
        songs = Song.where(user_id: params[:user_id])
        render json: songs
      end
    end
  end

  def create
    data = Hash[*params[:song].map{|k, v| [k.underscore, v]}.flatten]
    data[:spotify_id] = data.delete("id")
    data[:artists] = data.delete("artists").values
    s = Song.new data
    s.save!
    render json: {status: 'ok'}
  end
end
