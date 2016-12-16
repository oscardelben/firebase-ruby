module Firebase
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def body
      JSON.parse(response.body, :quirks_mode => true)
    end

    def raw_body
      response.body
    end

    def success?
      [200, 204].include? code
    end

    def code
      response.code.to_i
    end
  end
end
