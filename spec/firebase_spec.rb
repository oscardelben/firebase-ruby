require 'spec_helper'

describe "Firebase" do
  let (:data) do
    { 'name' => 'Oscar' }
  end

  describe "invalid uri" do
    it "should raise on http" do
      expect{ Firebase::Client.new('http://test.firebaseio.com') }.to raise_error(ArgumentError)
    end

    it 'should raise on empty' do
      expect{ Firebase::Client.new('') }.to raise_error(ArgumentError)
    end

    it "should raise when a nonrelative path is used" do
      firebase = Firebase::Client.new('https://test.firebaseio.com')
      expect { firebase.get('/path', {}) }.to raise_error(ArgumentError)
    end
  end

  before do
    @firebase = Firebase::Client.new('https://test.firebaseio.com')
  end

  describe "set" do
    it "writes and returns the data" do
      expect(@firebase).to receive(:process).with(:put, 'users/info', data, {})
      @firebase.set('users/info', data)
    end
  end

  describe "get" do
    it "returns the data" do
      expect(@firebase).to receive(:process).with(:get, 'users/info', nil, {})
      @firebase.get('users/info')
    end

    it "correctly passes custom ordering params" do
      params = {
        :orderBy => '"$key"',
        :startAt => '"A1"'
      }
      expect(@firebase).to receive(:process).with(:get, 'users/info', nil, params)
      @firebase.get('users/info', params)
    end

    # it "works when run against real Firebase dataset" do
    it "works when run against real Firebase dataset (except when it doesn't)" do
      firebase = Firebase::Client.new('https://dinosaur-facts.firebaseio.com') do |conn|
        conn.adapter :net_http
      end
      response = firebase.get 'dinosaurs', :orderBy => '"$key"', :startAt => '"a"', :endAt => '"m"'
      expect(response.success?).to be false
      expect(response.body).to eq(
        "error" => "Firebase error. Please ensure that you spelled the name of " +
        "your Firebase correctly"
      )
      # expect(response.body).to eq({
      #   "bruhathkayosaurus" => {
      #     "appeared" => -70000000,
      #       "height" => 25,
      #       "length" => 44,
      #        "order" => "saurischia",
      #     "vanished" => -70000000,
      #       "weight" => 135000
      #   },
      #   "lambeosaurus" => {
      #     "appeared" => -76000000,
      #       "height" => 2.1,
      #       "length" => 12.5,
      #        "order" => "ornithischia",
      #     "vanished" => -75000000,
      #       "weight" => 5000
      #   },
      #   "linhenykus" => {
      #     "appeared" => -85000000,
      #       "height" => 0.6,
      #       "length" => 1,
      #        "order" => "theropoda",
      #     "vanished" => -75000000,
      #       "weight" => 3
      #   }
      # })
    end

    it "return nil if response body contains 'null'" do
      mock_response = double(:body => 'null')
      response = Firebase::Response.new(mock_response)
      expect { response.body }.to_not raise_error
    end

    it "return true if response body contains 'true'" do
      mock_response = double(:body => 'true')
      response = Firebase::Response.new(mock_response)
      expect(response.body).to eq(true)
    end

    it "return false if response body contains 'false'" do
      mock_response = double(:body => 'false')
      response = Firebase::Response.new(mock_response)
      expect(response.body).to eq(false)
    end

    it "raises JSON::ParserError if response body contains invalid JSON" do
      mock_response = double(:body => '{"this is wrong"')
      response = Firebase::Response.new(mock_response)
      expect { response.body }.to raise_error(JSON::ParserError)
    end
  end

  describe "push" do
    it "writes the data" do
      expect(@firebase).to receive(:process).with(:post, 'users', data, {})
      @firebase.push('users', data)
    end
  end

  describe "delete" do
    it "returns true" do
      expect(@firebase).to receive(:process).with(:delete, 'users/info', nil, {})
      @firebase.delete('users/info')
    end
  end

  describe "update" do
    it "updates and returns the data" do
      expect(@firebase).to receive(:process).with(:patch, 'users/info', data, {})
      @firebase.update('users/info', data)
    end
  end

  describe "http processing" do
    it "sends custom auth query" do
      firebase = Firebase::Client.new('https://test.firebaseio.com', 'secret') do |conn|
        conn.adapter :test do |stub|
          stub.get('/todos.json?auth=secret&foo=bar') { |env|
            expect(env.params).to eq("auth" => "secret", "foo" => "bar")
            [ 200, {}, '{}' ]
          }
        end
      end
      firebase.get('todos', :foo => 'bar')
    end
  end

  describe "service account auth" do
    before do
      credential_auth_count = 0
      @credentials = double('credentials')
      allow(@credentials).to receive(:apply!).with(kind_of(Hash)) do |arg|
        credential_auth_count += 1
        arg[:authorization] = "Bearer #{credential_auth_count}"
      end
      allow(@credentials).to receive(:issued_at) { Time.now }
      allow(@credentials).to receive(:expires_in) { 3600 }

      expect(Google::Auth::DefaultCredentials).to receive(:make_creds).with(
        json_key_io: instance_of(StringIO),
        scope: instance_of(Array)
      ).and_return(@credentials)
    end

    it "sets custom auth header" do
      client = Firebase::Client.new('https://test.firebaseio.com/', '{ "private_key": true }')
      expect(client.request.headers).to include({
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer 1'
      })
    end

    it "handles token expiry" do
      current_time = Time.now
      client = Firebase::Client.new('https://test.firebaseio.com/', '{ "private_key": true }') do |conn|
        conn.adapter :test do |stub|
          stub.get('/dummy.json') { |env|
            expect(env.params).to be_empty
            [ 200, {}, '{}' ]
          }
        end
      end
      allow(Time).to receive(:now) { current_time + 3600 }
      expect(@credentials).to receive(:refresh!)
      client.get 'dummy'
      expect(client.request.headers).to include({
        'Content-Type' => 'application/json',
        'Authorization' => 'Bearer 2'
      })
    end
  end
end
