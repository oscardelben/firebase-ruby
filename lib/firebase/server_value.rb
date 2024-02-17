module Firebase
  class ServerValue
    TIMESTAMP = { '.sv' => 'timestamp' }.freeze

    def self.increment amount
      {'.sv' => { 'increment' => amount } }
    end
  end
end
