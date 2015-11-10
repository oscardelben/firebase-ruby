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
    @req = @firebase.request
  end

  describe "set" do
    it "writes and returns the data" do
      @firebase.should_receive(:process).with(:put, 'users/info', data, {})
      @firebase.set('users/info', data)
    end
  end

  describe "get" do
    it "returns the data" do
      @firebase.should_receive(:process).with(:get, 'users/info', {})
      @firebase.get('users/info')
    end

    it "return nil if response body contains 'null'" do
      mock_response = double(:body => 'null')
      response = Firebase::Response.new(mock_response)
      expect { response.body }.to_not raise_error
    end

    it "return true if response body contains 'true'" do
      mock_response = double(:body => 'true')
      response = Firebase::Response.new(mock_response)
      response.body.should eq(true)
    end

    it "return false if response body contains 'false'" do
      mock_response = double(:body => 'false')
      response = Firebase::Response.new(mock_response)
      response.body.should eq(false)
    end

    it "raises JSON::ParserError if response body contains invalid JSON" do
      mock_response = double(:body => '{"this is wrong"')
      response = Firebase::Response.new(mock_response)
      expect { response.body }.to raise_error
    end
  end

  describe "push" do
    it "writes the data" do
      @firebase.should_receive(:process).with(:post, 'users', data, {})
      @firebase.push('users', data)
    end
  end

  describe "delete" do
    it "returns true" do
      @firebase.should_receive(:process).with(:delete, 'users/info', {})
      @firebase.delete('users/info')
    end
  end

  describe "update" do
    it "updates and returns the data" do
      @firebase.should_receive(:process).with(:patch, 'users/info', data, {})
      @firebase.update('users/info', data)
    end
  end

  describe "http processing" do
    it "sends custom auth" do
      firebase = Firebase::Client.new('https://test.firebaseio.com', 'secret')
      firebase.request.should_receive(:request).with(:get, "todos.json", {
        :body => {:foo => 'bar'}.to_json,
        :query => {:auth => "secret"},
        :follow_redirect => true
      })
      firebase.get('todos', :foo => 'bar')
    end
  end
end
