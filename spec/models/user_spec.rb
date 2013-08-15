require 'spec_helper'

describe User do

  describe '#create' do
    context 'invalid' do
      it "doesn't creates user" do
        user = User.new(
          email: 'invalid@example.com',
          username: 'slides',
          password: 'password',
        )
        expect(user).to_not be_valid
      end
    end 
  end 

  # https://en.gravatar.com/site/implement/hash/
  describe 'avatar' do
    before do
      @user = User.new(
        email: 'myemailaddress@example.com'
      )
    end
    it 'returns gravatar url with default size' do
      expect(@user.avatar).to eq("//gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346.png?s=24&d=mm")
    end
    it 'returns gravatar url with specified size' do
      expect(@user.avatar(size: 64)).to eq("//gravatar.com/avatar/0bc83cb571cd1c50ba6f3e8a78ef1346.png?s=64&d=mm")
    end
  end

end
