require 'patron'
require 'json'

module Firebase
  class Request
    attr_reader :session

    def initialize(base_uri)
      @session = Patron::Session.new
      @session.base_url = base_uri
      @session.headers['Accept'] = 'application/json'
      @session.headers['Content-Type'] = 'application/json'
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
      response = session.request(method, "#{path}.json", {}, data: body, query: query_options)
      Firebase::Response.new(response)
    end
  end
end
