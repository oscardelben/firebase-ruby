require 'typhoeus'
require 'json'
require 'open-uri'
require 'uri'

module Firebase
  class Request

    attr_reader :base_uri

    def initialize(base_uri)
      @base_uri = base_uri
    end

    def get(path, query_options)
      process(:get, path, nil, query_options)
    end

    def put(path, value, query_options)
      process(:put, path, value.to_json, query_options)
    end

    def post(path, value, query_options)
      process(:post, path, value.to_json, query_options)
    end

    def delete(path, query_options)
      process(:delete, path, nil, query_options)
    end

    def patch(path, value, query_options)
      process(:patch, path, value.to_json, query_options)
    end

    def build_url(path)
      path = "#{path}.json"
      url = URI.join(base_uri, path)

      url.to_s
    end

    private

    def process(method, path, body=nil, query_options={})
      request = Typhoeus::Request.new(build_url(path),
                                      :body => body,
                                      :method => method,
                                      :params => query_options)
      response = request.run
      Firebase::Response.new(response)
    end

  end
end
