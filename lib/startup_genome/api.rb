require 'faraday'

module StartupGenome
  class API
    def initialize
      @host = 'http://startupgenome.co/api/'
      @path = 'organizations/city/'
      @auth_code = Rails.application.secrets.startup_genome_auth_code
      @location_slug = Rails.application.config.startup_genome_location_slug
      @conn = connect

      raise 'You must provide a Startup Genome Authorization Code' if @auth_code.nil?
      raise 'You must provide a Startup Genome Location Slug' if @location_slug.nil?
    end

    # TODO: Pass in organizations path to method rather than setting on obj creation
    def get_organizations
      @conn.get url, {}, {'auth-code' => @auth_code}
    end

    private

    def connect
      Faraday.new(:url => @host) do |faraday|
        faraday.request  :url_encoded            
        faraday.response :logger                 
        faraday.adapter  Faraday.default_adapter
      end
    end

    def url
      "#{@host}#{@path}#{@location_slug}"
    end
  end
end 
