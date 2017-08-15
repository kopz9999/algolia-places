# AlgoliaPlaces

Ruby Client for [Algolia Places API](https://community.algolia.com/places/rest.html)
The main purpose of this gem is to provide a geocoding solution based on Algolia Places

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'algolia_places'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install algolia_places

## Usage



```ruby

# Configure AlgoliaPlaces
# @param [Hash] opts the options to configure AlgoliaPlaces
# @option opts [String] :app_id Algolia App Id for PLACES
# @option opts [String] :api_key Algolia Api key
# @option opts [Boolean] :rest_exception (false) launch exception on REST errors
# @option opts [Logger] :logger by default STDOUT

AlgoliaPlaces.configuration app_id: 'ALGOLIA_APP_ID', api_key: 'ALGOLIA_API_KEY'

# Geocode

AlgoliaPlaces.coordinates '1649 HAVENBROOK, SUDBURY, Ontario'
# => [46.5333, -80.9329]

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kopz9999/algolia_places. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

