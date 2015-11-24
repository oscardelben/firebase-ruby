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
    it "sends custom auth" do
      firebase = Firebase::Client.new('https://test.firebaseio.com', 'secret')
      expect(firebase.request).to receive(:request).with(:get, "todos.json", {
        :body => nil,
        :query => {:auth => "secret", :foo => 'bar'},
        :follow_redirect => true
      })
      firebase.get('todos', :foo => 'bar')
    end
  end
end
