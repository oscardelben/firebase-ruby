class Firebase
  class Response

    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def body
      JSON.parse(response.body, :quirks_mode => true)
    rescue JSON::ParserError => e
      response.body == 'null' ? nil : raise
    end

    def raw_body
      response.body
    end

    def success?
      [200, 204].include? response.code
    end

    def code
      response.code
    end
  end
end
