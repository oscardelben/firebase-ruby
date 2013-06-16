require 'spec_helper'

describe "Firebase" do

  it 'should have a base_uri attribute' do
    Firebase.base_uri.should be_nil
    Firebase.base_uri = 'http://example.com/foo'
    Firebase.base_uri.should == 'http://example.com/foo/'
  end

  let (:data) do
    { 'name' => 'Oscar' }
  end

  describe "set" do
    it "writes and returns the data" do
      Firebase::Request.should_receive(:put).with('users/info', data)
      Firebase.set('users/info', data)
    end
  end

  describe "get" do
    it "returns the data" do
      Firebase::Request.should_receive(:get).with('users/info')
      Firebase.get('users/info')
    end

    it "return nil if response body contains 'null'" do
      mock_response = mock(:body => 'null')
      @request = Firebase::Request.new(mock_response)
      expect { @request.body }.to_not raise_error(JSON::ParserError)
    end

    it "raises JSON::ParserError if response body contains invalid JSON" do
      mock_response = mock(:body => '{"this is wrong"')
      @request = Firebase::Request.new(mock_response)
      expect { @request.body }.to raise_error(JSON::ParserError)
    end

  end

  describe "push" do
    it "writes the data" do
      Firebase::Request.should_receive(:post).with('users', data)
      Firebase.push('users', data)
    end
  end

  describe "delete" do
    it "returns true" do
      Firebase::Request.should_receive(:delete).with('users/info')
      Firebase.delete('users/info')
    end
  end

  describe "update" do
    it "updates and returns the data" do
      Firebase::Request.should_receive(:patch).with('users/info', data)
      Firebase.update('users/info', data)
    end
  end
end
