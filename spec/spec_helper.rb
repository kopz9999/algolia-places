$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'algolia_places'
require 'pry'

Dir["#{AlgoliaPlaces.root}/spec/support/**/*.rb"].each { |f| require f }
