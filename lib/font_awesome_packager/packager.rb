require 'net/http'
require 'json'

module FontAwesomePackager
  class Packager
    def initialize(font_endpoint = URI('http://icnfnt.com/api/createpack'))
      @endpoint = font_endpoint
      @fonts    = ['star-half', 'facebook', 'unlock']
    end

    def download!(out_file)
      File.open(out_file, 'w') { |f| f.write(font_file) }
    end

    private

    def data
      @fonts.map { |name| Font.new(name).to_hash }
    end

    def post_body
      { :json_data => data.to_json }
    end

    def font_file
      Net::HTTP.get(font_url)
    end

    def font_url
      response = Net::HTTP.post_form(@endpoint, post_body)

      URI("#{@endpoint.scheme}://#{@endpoint.host}#{response.body}")
    end
  end
end

