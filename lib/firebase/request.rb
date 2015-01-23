require 'httpclient'
require 'json'

module Firebase
  class Request
    def initialize(base_uri)
      @client = HTTPClient.new(base_url: base_uri)
      @client.default_header['Content-Type'] = 'application/json'
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

    private

    def process(method, path, body=nil, query_options={})
      response = @client.request(method, "#{path}.json", body: body, query: query_options, follow_redirect: true)
      Firebase::Response.new(response)
    end
  end
end
