# frozen_string_literal: true

require 'uri'
require 'httpclient'
require 'googleauth'
require 'json'

module Firebase
  # API requests to firebase API implemented here
  class Request
    attr_reader :http_client, :auth

    def initialize(uri:, auth:, headers: { 'Content-Type': 'application/json' })
      raise ArgumentError.new('base_uri must be a valid https uri') if uri !~ URI.regexp(%w(https))
      uri += '/' unless uri.end_with?('/')

      if valid_auth?(auth)
        # Using Admin SDK private key
        scopes = %w(https://www.googleapis.com/auth/firebase.database https://www.googleapis.com/auth/userinfo.email)
        credentials = Google::Auth::DefaultCredentials.make_creds(json_key_io: StringIO.new(auth), scope: scopes)
        headers = credentials.apply(headers)
      else
        # Using deprecated Database Secret
        @auth = auth
      end

      @http_client = HTTPClient.new(base_url: uri,
                                    default_header: headers)
    end

    def execute(method:, path:, data: nil, query: {})
      raise ArgumentError.new("Invalid path: #{path}. Path must be relative") if path.start_with? '/'

      params = { body: (data && data.to_json),
                 query: (@auth ? { auth: @auth }.merge(query) : query),
                 follow_redirect: true }

      http_call = http_client.request(method, "#{path}.json", params)
      Firebase::Response.new(http_call)
    end

    private

    def valid_auth?(auth)
      return false unless auth

      JSON.parse(auth)
      return true
    rescue TypeError
      return false
    rescue JSON::ParserError
      return false
    end
  end
end
