require 'uri'
require 'firebase/request'
require 'firebase/response'
require 'firebase/server_value'

module Firebase
  class Client
    attr_reader :auth, :request

    def initialize(base_uri, auth=nil)
      if base_uri !~ URI::regexp(%w(https))
        raise ArgumentError.new('base_uri must be a valid https uri')
      end
      base_uri += '/' unless base_uri.end_with?('/')
      @request = Firebase::Request.new(base_uri)
      @auth = auth
    end

    # Writes and returns the data
    #   Firebase.set('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def set(path, data, query={})
      request.put(path, data, query_options(query))
    end

    # Returns the data at path
    def get(path, query={})
      request.get(path, query_options(query))
    end

    # Writes the data, returns the key name of the data added
    #   Firebase.push('users', { 'age' => 18}) => {"name":"-INOQPH-aV_psbk3ZXEX"}
    def push(path, data, query={})
      request.post(path, data, query_options(query))
    end

    # Deletes the data at path and returs true
    def delete(path, query={})
      request.delete(path, query_options(query))
    end

    # Write the data at path but does not delete ommited children. Returns the data
    #   Firebase.update('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def update(path, data, query={})
      request.patch(path, data, query_options(query))
    end

    private

    def query_options(query)
      if auth
        { :auth => auth }.merge(query)
      else
        query
      end
    end
  end
end

