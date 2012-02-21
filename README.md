# What is it?

**spotify-metadata** is a Ruby gem that provides easy acces to the [Spotify Metadata API](http://developer.spotify.com/en/metadata-api/overview/). The API has serves two functions: searching for metadata – artist names and their Spotify URIs, the tracks in an album, the artist(s) of a track, etc – and looking up Spotify URLs.

# Usage

Here are some little, (mostly) useless examples for you to see how this gem works.

```ruby
require 'spotify'

# Searching
artists = Spotify::search_artist 'Radiohead'
puts artists.first.name # => 'Radiohead'

album = Spotify::search_album('The King of Limbs').first # notice .first.
puts "#{album.artist.name} - #{album.name}" # => Radiohead - Kid A

# Looking up Spotify URIs
artist = Spotify::lookup_artist 'spotify:artist:1Z2KInfSmPOzAIYyiaXeti', :album
puts artist.name # => 'Youth Lagoon'

artist.albums.join', ' # => 'The Year of Hibernation, The Year of Hibernation' (See the 'Known Bugs')

album = Spotify::lookup_album 'spotify:album:4oGbmR7dENuqtRyvX8MShq', :track
album.tracks.each do |track|
	track.name
end
```

# Installation

```ruby
gem install spotify-metadata
```

or when using Bundler:

```ruby
gem 'spotify-metadata', :require => 'spotify, :git => 'git://github.com/britishtea/spotify.git'
```

# Known Bugs

- Track numbers, artist IDs and external IDs can't be looked up (the API uses track-number). Use something like `Spotify::Track.send(:'track-number')` to work around this problem.
- When requesting the albums by an artist (`Spotify::lookup_artist url, :album`), the same album is sometimes listed more than once. This is due to Spotify providing different editions in different territories. Something like `artist.availability['territories']` can be used to filter out the relevant edition.

# License - MIT License

Copyright (C) 2012 Paul Brickfeld

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.