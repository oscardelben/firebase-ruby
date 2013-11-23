class Firebase

  require 'firebase/request'
  require 'firebase/response'

  class << self

    def format_uri(other)
      if other
        other.end_with?("/") ? other : other + '/'
      end
    end

    def base_uri=(other)
      deprecate
      default_instance.request.base_uri = format_uri(other)
    end

    def auth=(auth)
      deprecate
      default_instance.request.auth = auth
    end

    def set(path, data)
      deprecate
      default_instance.set(path, data)
    end

    def get(path)
      deprecate
      default_instance.get(path)
    end

    def push(path, data)
      deprecate
      default_instance.push(path, data)
    end

    def delete(path)
      deprecate
      default_instance.delete(path)
    end

    def update(path, data)
      deprecate
      default_instance.patch(path, data)
    end

    def default_instance
      @default_instance ||= Firebase.new(nil, nil)
    end

    def deprecate
      puts "[FIREBASE] This syntax has been deprecated. Please upgrade to the new Firebase.new(...).method syntax"
    end

  end

  attr_accessor :request

  def initialize(base_uri, auth=nil)
    uri = Firebase.format_uri(base_uri)
    @request = Firebase::Request.new(uri, auth)
  end

    # Writes and returns the data
    #   Firebase.set('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
  def set(path, data)
    request.put(path, data)
  end

  # Returns the data at path
  def get(path)
    request.get(path)
  end

  # Writes the data, returns the key name of the data added
  #   Firebase.push('users', { 'age' => 18}) => {"name":"-INOQPH-aV_psbk3ZXEX"}
  def push(path, data)
    request.post(path, data)
  end

  # Deletes the data at path and returs true
  def delete(path)
    request.delete(path)
  end

  # Write the data at path but does not delete ommited children. Returns the data
  #   Firebase.update('users/info', { 'name' => 'Oscar' }) => { 'name' => 'Oscar' }
  def update(path, data)
    request.patch(path, data)
  end

end

