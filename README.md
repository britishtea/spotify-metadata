# What is it?

This gem lets you access the [Spotify Metadata API](http://developer.spotify.com/en/metadata-api/overview/) easily.

# Usage

Here are some little, (mostly) useless examples for you to see how this gem works.

```ruby
require 'spotify'

# Searching
artists = Spotify.search_artist 'Radiohead'
puts artists.first.name # => 'Radiohead'

album = Spotify.search_album('The King of Limbs').first # notice .first.
puts "#{album.artist.name} - #{album.name}" # => Radiohead - Kid A

# Looking up Spotify URIs
artist = Spotify::lookup_artist 'spotify:artist:1Z2KInfSmPOzAIYyiaXeti', :album
artist.albums.each do |a|
	puts a.name
end

album = Spotify::lookup_album 'spotify:album:4oGbmR7dENuqtRyvX8MShq'
album.tracks.each do |track|
	track.name
end
```

# Install

```ruby
gem install spotify-metadata
```

or when using Bundler:

```ruby
gem 'spotify-metadata', :git => 'git://github.com/britishtea/spotify.git'
```

# Known Bugs

- Track numbers, artist IDs and external IDs can't be looked up (the API uses track-number). Use something like `Spotify::Track.send(:'track-number')` to work around this problem.
