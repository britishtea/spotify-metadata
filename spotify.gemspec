$:.push File.expand_path('../lib', __FILE__)
require 'spotify/version'

Gem::Specification.new do |s|
  s.name        = 'spotify'
  s.version     = Spotify::VERSION
  s.summary     = 'Search Spotify\' Metadata API using Ruby.'
  s.description = 'Search Spotify\' Metadata API using Ruby.'
  s.authors     = ["Paul Brickfeld"]
  s.email       = 'theboss@nearupon.com'
  s.files       = Dir.glob 'lib/*.rb'
  s.homepage    = 'https://github.com/britishtea/spotify'
  
  s.add_runtime_dependency 'httparty', '~> 0.8.1'
end