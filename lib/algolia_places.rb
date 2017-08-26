require 'json'
require 'singleton'
require 'forwardable'
require "rest-client"
require 'logger'
require 'jsonpath'

class AlgoliaPlaces
  URL = 'https://places-dsn.algolia.net/1/places/query'

  include Singleton

  class << self
    extend Forwardable
    def_delegators :instance, :coordinates, :coordinates
    def_delegators :instance, :hits, :hits
    def_delegators :instance, :configuration, :configuration
    
    def root
      File.expand_path '../..', __FILE__
    end
  end

  attr_writer :app_id
  attr_writer :api_key
  attr_writer :logger
  attr_accessor :rest_exception

  alias :rest_exception? :rest_exception 
  
  # Configure AlgoliaPlaces
  # @param [Hash] opts the options to configure AlgoliaPlaces
  # @option opts [String] :app_id Algolia App Id for PLACES
  # @option opts [String] :api_key Algolia Api key
  # @option opts [Boolean] :rest_exception (false) launch exception on REST errors
  # @option opts [Logger] :logger by default STDOUT
  def configuration(opts = {})
    self.app_id = opts.fetch :app_id
    self.api_key = opts.fetch :api_key
    self.rest_exception = opts.fetch :rest_exception, false
    self.logger = opts[:logger] if opts[:logger]
  end

  def coordinates(query)
    begin
      resp = retrieve_query(query)
      coordinates_response(resp)
    rescue RestClient::ExceptionWithResponse => err
      if self.rest_exception?
        raise err
      else
        self.logger.fatal("#{err}\n#{err.backtrace.inspect}")
        default_coords
      end
    end
  end
  
  def hits(query)
    begin
      resp = retrieve_query(query)
      hits_response(resp)
    rescue RestClient::ExceptionWithResponse => err
      if self.rest_exception?
        raise err
      else
        self.logger.fatal("#{err}\n#{err.backtrace.inspect}")
        []
      end
    end
  end

  protected
  
  def hits_response(resp)
    JsonPath.new('$.hits').on(resp.body).first
  end

  def coordinates_response(resp)
    results = JsonPath.new('$.hits[0]._geoloc').on resp.body
    geo_loc = results.first
    if geo_loc.nil?
      default_coords
    else
      [geo_loc['lat'], geo_loc['lng']]
    end
  end

  def default_coords
    [0,0]
  end

  def retrieve_query(query)
    RestClient.post(URL,
                    { query: query }.to_json,
                    {
                      'X-Algolia-Application-Id' => self.app_id,
                      'X-Algolia-API-Key' => self.api_key,
                    })
  end

  def app_id
    @app_id ||= ENV['ALGOLIA_APP_ID']
  end

  def api_key
    @api_key||= ENV['ALGOLIA_API_KEY']
  end
  
  def logger
    @logger||= setup_logger
  end
  
  private
  
  def setup_logger
    log = Logger.new(STDOUT)
    log.level = Logger::INFO
    log
  end
end
