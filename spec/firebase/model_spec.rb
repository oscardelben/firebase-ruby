require 'spec_helper'

class User < Firebase::Model
end

class UserWithListName < Firebase::Model
  self.list_name = 'users_list'
end

describe Firebase::Model do

  it "should have a default list_name" do
    User.list_name.should == "users"
  end

  it "should allow overriding the list_name" do
    UserWithListName.list_name.should == "users_list"
  end

  describe "set" do

    let (:data) do
      { 'name' => 'Oscar' }
    end

    it "saves the data" do
      Firebase::Request.should_receive(:put).with('users/name', data)
      User.set('name', data)
    end

  end

  describe "push"
end
