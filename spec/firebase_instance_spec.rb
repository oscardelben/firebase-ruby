require 'spec_helper'

describe 'an instance of Firebase' do

  let (:data) do
    { 'name' => 'Oscar' }
  end

  let(:instance) {Firebase.new('https://test.firebaseio.com')}

  describe 'instance set' do
    it "writes and returns the data" do
      Firebase::Request.should_receive(:put).with('users/info', data)
      instance.set('users/info', data)
    end
  end

  describe 'instance get' do
    it 'returns the data' do
      Firebase::Request.should_receive(:get).with('users/info')
      instance.get('users/info')
    end
  end

  describe 'instance push' do
    it 'writes the data' do
      Firebase::Request.should_receive(:post).with('users', data)
      instance.push('users', data)
    end
  end

  describe "instance delete" do
    it "returns true" do
      Firebase::Request.should_receive(:delete).with('users/info')
      instance.delete('users/info')
    end
  end

  describe "instance update" do
    it "updates the data" do
      Firebase::Request.should_receive(:patch).with('users/info', data)
      instance.update('users/info', data)
    end
  end

end
