require '../lib/spotify'
require 'minitest/autorun'

describe Spotify do
  describe 'when searching for artists' do
    it 'should return an Array of artists' do
      artists = Spotify::search_artist 'Madonna'
      
      assert_kind_of Array, artists
      assert_kind_of Spotify::Artist, artists.first
    end
    
    it 'should return nil' do
      artists = Spotify::search_artist 'Hdjaksfasf7832349dDJD'
      
      assert_equal nil, artists
    end
  end
  
  sleep(1)
  
  describe 'when searching for albums' do
    it 'should return an Array of albums' do
      albums = Spotify::search_album 'The King of Limbs'
      
      assert_kind_of Array, albums
      assert_kind_of Spotify::Album, albums.first
    end
    
    it 'should have an artist or an array of artists' do
      album = Spotify::search_album('The King of Limbs').first
      assert_kind_of Spotify::Artist, album.artist
    end
    
    it 'should return nil' do
      albums = Spotify::search_album 'Hdjaksfasf7832349dDJD'
      
      assert_equal nil, albums
    end
  end
  
  sleep(1)
  
  describe 'when searching for tracks' do
    it 'should return an Array of tracks' do
      tracks = Spotify::search_track 'Africa'
      
      assert_kind_of Array, tracks
      assert_kind_of Spotify::Track, tracks.first
    end
    
    it 'should have an album' do
      track = Spotify::search_track('Africa').first
      assert_kind_of Spotify::Album, track.album

      collab = Spotify::search_track('Revenge (Feat. The Flaming Lips)').first
      assert_kind_of Array, collab.artist
      assert_kind_of Spotify::Artist, collab.artist.first
    end
    
    it 'should return nil' do
      tracks = Spotify::search_track 'Hdjaksfasf7832349dDJD'
      
      assert_equal nil, tracks
    end
  end
end