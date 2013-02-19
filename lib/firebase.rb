
module Firebase

  autoload :Request, 'firebase/request'

  class << self
    attr_accessor :base_uri, :auth

    def base_uri=(other)
      if other # Guard from nil
        other = other + "/" if other[-1] != "/"
      end
      @base_uri = other
    end

    def auth=(auth)
      @auth = auth
    end

    # Writes and returns the data
    #   Firebase.set('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def set(path, data)
      Firebase::Request.put(path, data)
    end

    # Returns the data at path
    def get(path)
      Firebase::Request.get(path)
    end

    # Writes the data, returns the key name of the data added
    #   Firebase.push('users', { 'age' => 18}) => {"name":"-INOQPH-aV_psbk3ZXEX"}
    def push(path, data)
      Firebase::Request.post(path, data)
    end

    # Deletes the data at path and returs true
    def delete(path)
      Firebase::Request.delete(path)
    end

    # Write the data at path but does not delete ommited children. Returns the data
    #   Firebase.update('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
    def update(path, data)
      Firebase::Request.patch(path, data)
    end

  end
end
