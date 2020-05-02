class SongsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    respond_to do |f|
      f.html
      f.json do
        songs = Song.where(user_id: params[:user_id]).order(:seq)
        render json: songs.map(&:to_front)
      end
    end
  end

  def itunes_link
    load_song
    unless @song.itunes_link.present?
      @song.fetch_itunes_link
    end
    if @song.valid_itunes_link?
      render json: {itunes_link: @song.itunes_link}
    else
      render json: {status: 'not_found'}
    end
  end

  def update_sequence
    params[:sequence].each_with_index do |id, i|
      Song.where(spotify_id: id).update_all seq: i
    end
    render json: {status: 'ok'}
  end

  def destroy
    load_song
    @song.destroy
    render json: {status: 'ok'}
  end

  def create
    s = Song.new(
      name: params[:song][:name],
      spotify_id: params[:song][:id],
      artists: params[:song][:artists].values,
      album: params[:song][:album],
      user_id: params[:song][:userID]
    )
    s.save!
    render json: {status: 'ok'}
  end

  private
  def load_song
    @song = Song.where(spotify_id: params[:id]).last
  end
end
