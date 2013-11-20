require 'spec_helper'

describe "Firebase Request" do

  after do
    Firebase.base_uri = nil
    Firebase.auth = nil
  end

  describe "url_builder" do
    it "should build the correct url when passed no path" do
      Firebase.base_uri = 'https://test.firebaseio.com'
      Firebase::Request.build_url(nil).should == 'https://test.firebaseio.com/.json'
    end
  end

  describe "url_builder" do
    it "should build the correct url when passed a path" do
      Firebase.base_uri = 'https://test.firebaseio.com'

      Firebase::Request.build_url('users/eugene').should == 'https://test.firebaseio.com/users/eugene.json'
    end
  end

  describe "url_builder for FirebaseInstance" do
    it "should build the correct url when an instance calls it" do
      Firebase.base_uri = 'https://test.firebaseio.com'
      firebase_instance = Firebase.new("https://instance.firebaseio.com")
      firebase_instance.set_base_uri

      Firebase::Request.build_url('users/eugene').should == 'https://instance.firebaseio.com/users/eugene.json'

    end

    it "should default to Firebase.base_uri if none is given to the instance" do
      Firebase.base_uri = 'https://test.firebaseio.com'
      firebase_instance = Firebase.new
      firebase_instance.set_base_uri

      Firebase::Request.build_url('users/eugene').should == 'https://test.firebaseio.com/users/eugene.json'
    end
  end
  
  describe "auth for FirebaseInstance" do
    it "should use the auth passed from the instance" do
      Firebase.base_uri = 'https://test.firebaseio.com'
      firebase_instance = Firebase.new(nil, 'secretkey')
      firebase_instance.set_auth
      Firebase::Request.build_url('users/eugene').should == 'https://test.firebaseio.com/users/eugene.json?auth=secretkey'
    end
  end 

  describe "url_builder" do
    it "should include a auth in the query string, if configured" do
      Firebase.base_uri = 'https://test.firebaseio.com'
      Firebase.auth = 'secretkey'

      Firebase::Request.build_url('users/eugene').should == 'https://test.firebaseio.com/users/eugene.json?auth=secretkey'
    end
  end
end
