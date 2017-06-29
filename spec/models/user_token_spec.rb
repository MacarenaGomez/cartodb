describe UserTokenController do
  UserToken.instance

  let(:user_token) { UserToken.clone }
  it_behaves_like 'UserToken model'

  before(:each) do
    @user = create_user
  end

  after(:each) do
    @user.destroy
  end

  describe 'token validation' do
    it '.Instance always refers to the same instance' do
      user_token.instance.should be_a_kind_of UserToken
      user_token.instance.should equal UserToken.instance
    end
  end
end
