require 'spec_helper'

describe "Firebase Request" do

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

  describe "url_builder" do
    it "should include a key in the query string, if configured" do
      Firebase.base_uri = 'https://test.firebaseio.com'
      Firebase.key = 'secretkey'

      Firebase::Request.build_url('users/eugene').should == 'https://test.firebaseio.com/users/eugene.json?key=secretkey'
    end
  end
end
