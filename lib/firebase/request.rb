require 'typhoeus'
require 'json'
require 'open-uri'
require 'uri'

class Firebase
  class Request

    attr_accessor :base_uri, :auth

    def initialize(base_uri, auth=nil)
      @base_uri = base_uri
      @auth = auth
    end

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
      path = "#{path}.json"
      query_string = auth ? "?auth=#{auth}" : ""
      url = URI.join(base_uri, path, query_string)

      url.to_s
    end

    private

    def process(method, path, options={})
      @@hydra ||= Typhoeus::Hydra.new
      request = Typhoeus::Request.new(build_url(path),
                                      :body => options[:body],
                                      :method => method)
      @@hydra.queue(request)
      @@hydra.run

      Firebase::Response.new(request.response)
    end
  end
end
