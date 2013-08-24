require 'typhoeus'
require 'json'
require 'open-uri'
require 'uri'

module Firebase
  class Request

    class << self

      def get(path)
        process(:get, path)
      end

      def put(path, value)
        process(:put, path, :body => value.to_json)
      end

      def post(path, value)
        process(:post, path, :body => value.to_json)
      end

      def delete(path)
        process(:delete, path)
      end

      def patch(path, value)
        process(:patch, path, :body => value.to_json)
      end

      def build_url(path)
        host = Firebase.base_uri
        path = "#{path}.json"
        query_string = Firebase.auth ? "?auth=#{Firebase.auth}" : ""
        url = URI.join(Firebase.base_uri, path, query_string)

        url.to_s
      end

      private

      def process(method, path, options={})
        raise "Please set Firebase.base_uri before making requests" unless Firebase.base_uri

	      @@hydra ||= Typhoeus::Hydra.new
        request = Typhoeus::Request.new(build_url(path),
                                        :body => options[:body],
                                        :method => method)
        @@hydra.queue(request)
        @@hydra.run

        new request.response
      end

    end

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def body
      JSON.parse(response.body, :quirks_mode => true)
    rescue JSON::ParserError => e
      response.body == 'null' ? nil : raise
    end

    def raw_body
      response.body
    end

    def success?
      [200, 204].include? response.code
    end

    def code
      response.code
    end

  end
end
