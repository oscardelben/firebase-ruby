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

  describe 'initialize request' do
    it 'returns firebase request object' do
      expect(@firebase.request).to be_a(Firebase::Request)
    end

    it 'returns nil auth' do
      expect(@firebase.request.auth).to be nil
    end

    it 'returns string auth token' do
      auth_firebase = Firebase::Client.new('https://test.firebaseio.com', 'fakefirebasetoken')
      expect(auth_firebase.request.auth).to eq 'fakefirebasetoken'
    end

    it 'returns http_client object' do
      expect(@firebase.request.http_client).to be_a HTTPClient
    end

    it 'returns default header' do
      expect(@firebase.request.http_client.default_header).to eq({ 'Content-Type': 'application/json'})
    end

    it 'returns base_url' do
      expect(@firebase.request.http_client.base_url).to eq 'https://test.firebaseio.com/'
    end        
  end

  describe 'set' do
    it 'writes and returns the data' do
      expect(@firebase.request).to receive(:execute).with(method: :put, path: 'users/info', data: data, query: {})
      @firebase.set('users/info', data)
    end

    it 'writes and returns the data' do
      expect(@firebase.request).to receive(:execute).with(method: :put, path: 'users/info', data: data, query: {})
      @firebase.put('users/info', data)
    end    
  end

  describe "get" do
    it "returns the data" do
      expect(@firebase.request).to receive(:execute).with(method: :get, path: 'users/info', query: {})
      @firebase.get('users/info')
    end

    it "correctly passes custom ordering params" do
      params = {
        :orderBy => '"$key"',
        :startAt => '"A1"'
      }
      expect(@firebase.request).to receive(:execute).with(method: :get, path: 'users/info', query: params)
      @firebase.get('users/info', params)
    end

    it "works when run against real Firebase dataset" do
      firebase = Firebase::Client.new 'https://dinosaur-facts.firebaseio.com'
      response = firebase.get 'dinosaurs', :orderBy => '"$key"', :startAt => '"a"', :endAt => '"m"'
      expect(response.body).to eq({
        "bruhathkayosaurus" => {
          "appeared" => -70000000,
            "height" => 25,
            "length" => 44,
             "order" => "saurischia",
          "vanished" => -70000000,
            "weight" => 135000
        },
        "lambeosaurus" => {
          "appeared" => -76000000,
            "height" => 2.1,
            "length" => 12.5,
             "order" => "ornithischia",
          "vanished" => -75000000,
            "weight" => 5000
        },
        "linhenykus" => {
          "appeared" => -85000000,
            "height" => 0.6,
            "length" => 1,
             "order" => "theropoda",
          "vanished" => -75000000,
            "weight" => 3
        }
      })
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

  describe 'push/post' do
    it 'writes the data' do
      expect(@firebase.request).to receive(:execute).with(method: :post, path: 'users', data: data, query: {})
      @firebase.push('users', data)
    end

    it 'writes the data' do
      expect(@firebase.request).to receive(:execute).with(method: :post, path: 'users', data: data, query: {})
      @firebase.post('users', data)
    end    
  end

  describe 'delete/destroy' do
    it 'returns true' do
      expect(@firebase.request).to receive(:execute).with(method: :delete, path: 'users/info', query: {})
      @firebase.delete('users/info')
    end

    it 'returns true' do
      expect(@firebase.request).to receive(:execute).with(method: :delete, path: 'users/info', query: {})
      @firebase.destroy('users/info')
    end    
  end

  describe "update" do
    it "updates and returns the data" do
      expect(@firebase.request).to receive(:execute).with(method: :patch, path: 'users/info', data: data, query: {})
      @firebase.update('users/info', data)
    end
  end

  describe "http processing" do
    it "sends custom auth query" do
      firebase = Firebase::Client.new('https://test.firebaseio.com', 'secret')
      expect(firebase.request.http_client).to receive(:request).with(:get, 'todos.json', {
        :body => nil,
        :query => {:auth => "secret", :foo => 'bar'},
        :follow_redirect => true
      })

      firebase.get('todos', :foo => 'bar')
    end

    it "sets custom auth header" do
      private_key = '{ "private_key": true }'
      credentials = double()
      expect(credentials).to receive(:apply).with({ 'Content-Type': 'application/json' }).and_return({ authorization: 'Bearer abcdef', 'Content-Type': 'application/json' })
      expect(StringIO).to receive(:new).with(private_key).and_return('StringIO private key')
      expect(Google::Auth::DefaultCredentials).to receive(:make_creds).with(json_key_io: 'StringIO private key', scope: instance_of(Array)).and_return(credentials)
      expect(HTTPClient).to receive(:new).with({
        base_url: 'https://test.firebaseio.com/',
        default_header: {
          authorization: 'Bearer abcdef',
          'Content-Type': 'application/json'
        }
      })

      Firebase::Client.new('https://test.firebaseio.com/', private_key)
    end
  end
end
