require 'firebase/response'
require 'firebase/server_value'
require 'net/https'
require 'json'
require 'uri'

module Firebase
  class Client
    attr_reader :auth, :request

    def initialize(base_uri, auth=nil)
      if base_uri !~ URI::regexp(%w(https))
        raise ArgumentError.new('base_uri must be a valid https uri')
      end
      uri = URI.parse(base_uri)
      @request = Net::HTTP.new(uri.host, uri.port)
      @request.use_ssl = true
      @request.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @auth = auth
    end

    # Writes and returns the data
    #   Firebase.set('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def set(path, data, query={})
      process :put, path, data, query
    end

    # Returns the data at path
    def get(path, query={})
      process :get, path, nil, query
    end

    # Writes the data, returns the key name of the data added
    #   Firebase.push('users', { 'age' => 18}) => {"name":"-INOQPH-aV_psbk3ZXEX"}
    def push(path, data, query={})
      process :post, path, data, query
    end

    # Deletes the data at path and returs true
    def delete(path, query={})
      process :delete, path, nil, query
    end

    # Write the data at path but does not delete ommited children. Returns the data
    #   Firebase.update('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def update(path, data, query={})
      process :patch, path, data, query
    end

    private

    def process(verb, path, data=nil, query={})
      request_class = case verb
                      when :put
                        Net::HTTP::Put
                      when :get
                        Net::HTTP::Get
                      when :post
                        Net::HTTP::Post
                      when :delete
                        Net::HTTP::Delete
                      when :patch
                        Net::HTTP::Patch
                      else
                        raise ArgumentError.new("Unsupported verb: #{verb}")
                      end
      query_params = URI.encode_www_form(@auth ? { :auth => @auth }.merge(query) : query)
      message = request_class.new(["/#{path}.json", query_params].join("?"))
      message["Content-Type"] = "application/json"
      message.body = data.to_json if data
      Firebase::Response.new(@request.request(message))

    end
  end
end
