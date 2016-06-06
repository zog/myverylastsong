class UsersController < ApplicationController
  def show
    @user = User.where(fb_id: params[:user_id]).last
    @songs = Song.where(user_id: params[:user_id])
  end

  def upsert
    u = User.where(fb_id: params[:id]).last
    u ||= User.new fb_id: params[:id]
    u.first_name = params[:first_name]
    u.last_name = params[:last_name]
    u.gender = params[:gender]
    u.save
    render json: {status: 'ok'}
  end
end
