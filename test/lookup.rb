require '../lib/spotify'
require 'minitest/autorun'

describe Spotify do
  describe 'when looking up artist URIs' do
    before do
      @uri = 'spotify:artist:1Z2KInfSmPOzAIYyiaXeti'
    end
    
    it 'should return an Spotify::Artist object' do
      artist = Spotify::lookup_artist @uri
      
      assert_kind_of Spotify::Artist, artist
      assert_equal 'Youth Lagoon', artist.name
    end
    
    it 'should be possible to request albums' do
      artist = Spotify::lookup_artist @uri, :album
      assert_kind_of Array, artist.albums
      assert_kind_of Spotify::Album, artist.albums.first 
      assert_kind_of Spotify::Artist, artist.albums.first.artist
    end
    
    it 'should be possible to request albums in detail' do 
      artist = Spotify::lookup_artist @uri, :albumdetail
      assert_equal 2011, artist.albums.first.released.to_i
    end
  end
  
  sleep(1)
  
  describe 'when looking up album URIs' do
    before do
      @uri = 'spotify:album:4oGbmR7dENuqtRyvX8MShq'
    end
    
    it 'should return an Spotify::Album object' do
      album = Spotify::lookup_album @uri
      
      assert_kind_of Spotify::Album, album
      assert_kind_of Spotify::Artist, album.artist
      assert_equal 'The Year of Hibernation', album.name
    end
    
    it 'should be possible to request tracks' do
      album = Spotify::lookup_album @uri, :track
      
      assert_kind_of Array, album.tracks
      assert_kind_of Spotify::Track, album.tracks.first 
      assert_kind_of Spotify::Artist, album.tracks.first.artist
    end
    
    it 'should be possible to request albums in detail' do 
      album = Spotify::lookup_album @uri, :trackdetail
      assert_equal 231, album.tracks.first.length.to_i
    end
  end
  
  sleep(1)
  
  describe 'when looking up track URIs' do
    before do
      @uri = 'spotify:track:2nIehotfpLCh7iPEYMIxPN'
    end
    
    it 'should return an Spotify::Track object' do
      track = Spotify::lookup_track @uri
      
      assert_kind_of Spotify::Track, track
      assert_kind_of Spotify::Artist, track.artist
      assert_kind_of Spotify::Album, track.album
      assert_equal 'Posters', track.name
    end
  end
end