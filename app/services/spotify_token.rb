require 'net/http'

# URL to get the code: https://accounts.spotify.com/fr/authorize?response_type=code&client_id=cd7f06135c6543b5834d1bdc8ff0908d&redirect_uri=http:%2F%2Fmyverylastsong.com&scope=playlist-modify-public

class SpotifyToken
  def self.access_token
    @_access_token ||= begin
      uri = URI.parse('https://accounts.spotify.com/api/token')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      header = {}
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.basic_auth ENV.fetch('SPOTIFY_CLIENT_ID'), ENV.fetch('SPOTIFY_CLIENT_SECRET')
      request.set_form_data(
        grant_type: 'refresh_token',
        refresh_token: ENV.fetch('SPOTIFY_REFRESH_TOKEN')
      )

      # Send the request
      response = http.request(request)
      JSON.parse(response.body).dig('access_token')
    end
  end

  def self.mvls_user
    RSpotify::User.new 'id' => ENV.fetch('SPOTIFY_USER_ID'), 'credentials' => { 'token' => access_token }
  end

end