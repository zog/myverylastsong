class UsersController < ApplicationController
  def show
    @user = User.where(fb_id: params[:user_id]).last
    @songs = Song.where(user_id: params[:user_id])
  end

  def upsert
    u = User.where(fb_id: params[:id]).last
    u ||= User.new fb_id: params[:id]
    u.name = params[:name]
    u.save
    render json: {status: 'ok'}
  end
end
