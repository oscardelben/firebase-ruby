require 'typhoeus'
require 'json'

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

      private

      def process(method, path, options={})
        raise "Please set Firebase.base_uri before making requests" unless Firebase.base_uri

        url = URI.join(Firebase.base_uri, path)
        url = [url, '.json'].compact.join

        request = Typhoeus::Request.new(url.to_s,
                                        :body => options[:body],
                                        :method => method)
        hydra = Typhoeus::Hydra.new
        hydra.queue(request)
        hydra.run

        new request.response
      end

    end

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def body
      JSON.parse(response.body)
    end

    def raw_body
      response.body
    end

    def success?
      response.code.in? [200, 204]
    end

    def code
      response.code
    end

  end
end
