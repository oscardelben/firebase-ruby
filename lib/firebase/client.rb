# frozen_string_literal: true

module Firebase
  # All Database interactions implemented here
  class Client
    attr_reader :request

    def initialize(base_uri, auth = nil)
      @request = Request.new(uri: base_uri,
                             auth: auth)
    end

    # Writes and returns the data
    # Firebase.set('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def set(path, data, query = {})
      request.execute(method: :put, path: path,
                      data: data, query: query)
    end

    # Returns the data at path
    def get(path, query = {})
      request.execute(method: :get, path: path,
                      query: query)
    end

    # Writes the data, returns the key name of the data added
    # Firebase.push('users', { 'age' => 18}) => {"name":"-INOQPH-aV_psbk3ZXEX"}
    def push(path, data, query = {})
      request.execute(method: :post, path: path,
                      data: data, query: query)
    end

    # Deletes the data at path and returs true
    def delete(path, query = {})
      request.execute(method: :delete, path: path,
                      query: query)
    end

    # Write the data at path but does not delete ommited
    # children. Returns the data
    # Firebase.update('users/info',
    # { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def update(path, data, query = {})
      request.execute(method: :patch, path: path,
                      data: data, query: query)
    end

    # Aliasing methods to match usual Ruby/Rails http methods
    alias post push
    alias put set
    alias destroy delete
  end
end
