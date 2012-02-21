require 'httparty'
require 'ostruct'

# Public: Various methods for interacting with the Spotify Metadata API. Please
# read the Terms of Use for this API (http://is.gd/0Mcl04) before using it.
#
# Examples
# 
#   require 'spotify'
#   
#   artists = Spotify.search_artist 'Radiohead'
#   puts artists.first.name # => 'Radiohead'
#   
#   album = Spotify.search_album('The King of Limbs').first
#   puts "#{album.artist.name} - #{album.name}" # => Radiohead - Kid A
module Spotify
  include HTTParty
  base_uri 'ws.spotify.com'
  format   :json
  headers  'Accept' => 'application/json' # Spotify prefers Accept headers.
  
  # Internal: The version Integer of Spotify's API.
  API_VERSION = 1
  
  # Public: Searches the Spotify API for artists.
  #
  # name    - The name String of the artist.
  # options - The Hash options send along with the request (default: {}).
  #           :page - The page of the result set (optional).
  #
  # Returns nil or an Array of Spotify::Artist objects.
  # Raises a SocketError if there's something wrong with the connection.
  def self.search_artist(name, options = {})
    self.search :artist, options.merge(:q => name)
  end
  
  # Public: searches the Spotify API for albums.
  #
  # name    - The name String of the album.
  # options - The Hash options send along with the request (default: {}).
  #           :page - The page of the result set (optional).
  #
  # Returns nil or an Array of Spotify::Album objects.
  # Raises a SocketError if there's something wrong with the connection.
  def self.search_album(name, options = {})
    self.search :album, options.merge(:q => name)
  end
  
  # Public: searches the Spotify API for tracks.
  #
  # name    - The name String of the track.
  # options - The Hash options send along with the request (default: {}).
  #           :page - The page of the result set (optional).
  #
  # Returns nil or an Array of Spotify::Track objects.
  # Raises a SocketError if there's something wrong with the connection.
  def self.search_track(name, options = {})
    self.search :track, options.merge(:q => name)
  end
  
  # Public: Looks up an Spotify artist URI.
  #
  # uri    - The Spotify URI String that needs to be lookup up.
  # extras - A Symbol that define the detail level expected in the response
  #          (default: nil).
  #          :album       - request basic information about all the albums the 
  #                         artist is featured in.
  #          :albumdetail - request detailed information about all the albums 
  #                         the artist is featured in
  #
  # Returns nil or an Spotify::Artist object.
  # Raises a SocketError if there's something wrong with the connection.
  def self.lookup_artist(uri, extras = nil)
    query = extras.nil? ? { :uri => uri } : { :uri => uri, :extras => extras }
    
    artist = Artist.new self.lookup(query)['artist']
    artist.albums.map! { |album| Album.new album['album'] } if extras
    
    artist
  end

  # Public: Looks up an Spotify album URI.
  #
  # uri    - The Spotify URI String that needs to be lookup up.
  # extras - A Symbol that defines the detail level expected in the response 
  #          (default: nil).
  #          :track       - request basic information about all tracks in the
  #                         album.
  #          :trackdetail - request detailed information about all tracks in the
  #                         album.
  #
  # Returns nil or an Spotify::Album object.
  # Raises a SocketError if there's something wrong with the connection.
  def self.lookup_album(uri, extras = nil)
    query = extras.nil? ? { :uri => uri } : { :uri => uri, :extras => extras }
    
    album = Album.new self.lookup(query)['album']
    album.tracks.map! { |track| Track.new track } if extras
    
    album
  end

  # Public: Looks up an Spotify track URI.
  #
  # uri    - The Spotify URI String that needs to be lookup up.
  #
  # Returns nil or an Spotify::Track object.
  # Raises a SocketError if there's something wrong with the connection.
  def self.lookup_track(uri)
    Track.new self.lookup(:uri => uri)['track']
  end
  
  # Internal: Represents an artist.
  class Artist < OpenStruct; end
  
  # Internal: Represents an album.
  class Album < OpenStruct
    # Public: Gets the artists.
    #
    # Returns an Array of Spotify::Artist objects.
    def artists
      super.nil? ? super : super.map { |artist| Artist.new artist }
    end
    
    # Public: Gets the artist of artists.
    #
    # Returns an Array of Spotify::Artist objects or a Spotify::Artist object
    # if only one artist was returned.
    def artist
      if artists.nil?
        Artist.new :name => super
      elsif artists.size > 1
        artists
      else
        artists.first
      end
    end
  end
  
  # Internal: Represents a track.
  class Track < Album
    # Public: Gets the album.
    #
    # Returns a Spotify::Album object.
    def album
      Album.new super
    end
  end

private

  # Internal: Performs a search query.
  #
  # method - The API method Symbol that needs to be called.
  # query  - The query Hash that needs to be passed.
  #
  # Returns nil or an Array of artist, album or track objects.
  # Raises a SocketError if there's something wrong with the connection.
  def self.search(method, query)
    result = get "/search/#{API_VERSION}/#{method}", :query => query
    
    items = result[method.to_s + 's']
    return if items.nil? || items.empty?
    
    items.map do |item|
      # TODO: Replace hyphens with underscores, so OpenStruct can use them as
      # methods.
      self.const_get(method.to_s.capitalize).new item
    end
  end
  
  # Internal: Performs a lookup query.
  #
  # query - The query String that needs to be passed. 
  #
  # Returns a JSON object contained in a Hash.
  # Raises a SocketError if there's something wrong with the connection.
  def self.lookup(query)
    get "/lookup/#{API_VERSION}/", :query => query
  end
end