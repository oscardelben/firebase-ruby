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
end
