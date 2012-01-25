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
  headers  'Accept' => 'application/json' # Spotify API prefers Accept headers.
  
  # Internal: The version Integer of Spotify's API.
  API_VERSION = 1
  
  # Public: Searches the Spotify API for artists.
  #
  # name    - The name String of the artist.
  # options - The Hash options send along with the request (default: {}).
  #           :page - The page of the result set (optional).
  #
  # Returns an Array of Spotify::Artist objects.
  def self.search_artist(name, options = {})
    self.search :artist, options.merge(:q => name)
  end
  
  # Public: searches the Spotify API for albums.
  #
  # name    - The name String of the album.
  # options - The Hash options send along with the request (default: {}).
  #           :page - The page of the result set (optional).
  #
  # Returns an Array of Spotify::Album objects.
  def self.search_album(name, options = {})
    self.search :album, options.merge(:q => name)
  end
  
  # Public: searches the Spotify API for tracks.
  #
  # name    - The name String of the track.
  # options - The Hash options send along with the request (default: {}).
  #           :page - The page of the result set (optional).
  #
  # Returns an Array of Spotify::Track objects.
  def self.search_track(name, options = {})
    self.search :track, options.merge(:q => name)
  end
  
  # Internal: Represents an artist.
  class Artist < OpenStruct
  end
  
  # Internal: Represents an album.
  class Album < OpenStruct
    # Public: Gets the artists.
    #
    # Returns an Array of Spotify::Artist objects.
    def artists
      super.map { |artist| Artist.new artist }
    end
    
    # Public: Gets the artist of artists.
    #
    # Returns an Array of Spotify::Artist objects or a Spotify::Artist object
    # if only one artist was returned.
    def artist
      artists.size > 1 ? artists : artists.first
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
  # Returns an Array of artist, album or track objects.
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
  # method -
  # query  -
  #
  # Returns
  def self.lookup(method, query)
    puts 'This method is not yet implemented'
    #result = get "/lookup/#{API_VERSION}/#{method}.json", :query => query
    #
    #self.const_get(methods.to_s.capitalize).new result
  end
end