class Firebase

  autoload :Request, 'firebase/request'

  class << self
    attr_accessor :base_uri, :auth

    def base_uri=(other)
      @base_uri = format_uri(other)
    end

    def format_uri(other)
      if other
        other.end_with?("/") ? other : other + '/'
      end
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

  attr_accessor :auth
  attr_reader :base_uri

  def initialize(base_uri = Firebase.base_uri, auth = Firebase.auth)
    @base_uri = base_uri
    @auth = auth
  end

  def base_uri=(str)
    @base_uri = Firebase.format_uri(str)
  end

  def set_base_uri
    Firebase::Request.set_uri(@base_uri)
  end

  def set_auth
    Firebase::Request.set_auth(@auth)
  end

  def set_request
    set_base_uri
    set_auth
  end

  def set(path, data)
    set_request
    Firebase.set(path, data)
  end

  def get(path)
    set_request
    Firebase.get(path)
  end

  def push(path, data)
    set_request
    Firebase.push(path, data)
  end

  def delete(path)
    set_request
    Firebase.delete(path)
  end

  def update(path, data)
    set_request
    Firebase.update(path, data)
  end

end

