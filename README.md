# Usage

Here are some little, (mostly) useless examples for you to see how this gem works.

	require 'spotify'
	
	artists = Spotify.search_artist 'Radiohead'
	puts artists.first.name # => 'Radiohead'
	
	album = Spotify.search_album('The King of Limbs').first
	puts "#{album.artist.name} - #{album.name}" # => Radiohead - Kid A

# Known Bugs

- Track numbers and external IDs can't be looked up (the API uses track-number). Use something like `Spotify::Track.send(:'track-number')` to work around this problem.
