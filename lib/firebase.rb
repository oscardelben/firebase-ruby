
module Firebase

  autoload :Request, 'firebase/request'

  class << self
    attr_accessor :base_uri

    def base_uri=(other)
      other = other + "/" if other[-1] != "/"
      @base_uri = other
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
      Firebase::Request.push(path, data)
    end

    # Deletes the data at path and returs true
    def delete(path)
      Firebase::Request.delete(path)
    end
  end
end
