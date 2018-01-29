# frozen_string_literal: true

module Firebase
  # All Database interactions implemented here
  class Client
    attr_reader :request

    def initialize(base_uri, auth = nil)
      @request = Request.new(base_uri, auth)
    end

    # Writes and returns the data
    # Firebase.set('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def set(path, data, query = {})
      request.execute(:put, path, data, query)
    end

    # Returns the data at path
    def get(path, query = {})
      request.execute(:get, path, nil, query)
    end

    # Writes the data, returns the key name of the data added
    # Firebase.push('users', { 'age' => 18}) => {"name":"-INOQPH-aV_psbk3ZXEX"}
    def push(path, data, query = {})
      request.execute(:post, path, data, query)
    end

    # Deletes the data at path and returs true
    def delete(path, query = {})
      request.execute(:delete, path, nil, query)
    end

    # Write the data at path but does not delete ommited
    # children. Returns the data
    # Firebase.update('users/info',
    # { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def update(path, data, query = {})
      request.execute(:patch, path, data, query)
    end

    # Aliasing methods to match usual Ruby/Rails http methods
    alias post push
    alias put set
    alias destroy delete
  end
end
