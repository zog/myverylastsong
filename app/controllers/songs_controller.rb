class SongsController < ApplicationController
  def index
    respond_to do |f|
      f.html
      f.json do
        songs = Song.where(user_id: params[:user_id]).order(:seq)
        render json: songs.map(&:to_front)
      end
    end
  end

  def update_sequence
    params[:sequence].each_with_index do |id, i|
      Song.where(spotify_id: id).update_all seq: i
    end
    render json: {status: 'ok'}
  end

  def destroy
    song = Song.where(spotify_id: params[:id]).last
    song.destroy
    render json: {status: 'ok'}
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
