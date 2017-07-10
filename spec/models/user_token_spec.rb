# coding: UTF-8
require_relative '../spec_helper'

require 'rspec/mocks'
require 'rspec/mocks/standalone'

describe UserToken do

  before(:each) do
    @user = FactoryGirl.create(:valid_user)
  end

  after(:each) do
    delete_user_data @user
    File.truncate('tokens.csv', 0)
  end

  let(:content) { "abcd1234,user00000003,table00000004,RW\n" }
  let(:permission) { "RW" }
  let(:dataset) { "table00000004" }
  let(:token) { "abcd1234" }

  specify 'Instance always refers to the same instance' do

    UserToken.instance.should be_a_kind_of UserToken
    UserToken.instance.should equal UserToken.instance

  end

  it 'should validate the new token as an uuid string'  do

    UserToken.instance.generate_token(dataset, "R", @user.username).should match(/\A[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}\z/i)

  end

  it 'should returns a new token and store it' do

    File.should_receive(:open).and_return(nil)
    SecureRandom.should_receive(:uuid).and_return("abcd1234")

    count = UserToken.instance.get_number_of_tokens

    UserToken.instance.generate_token(dataset, permission, @user.username).should == "abcd1234"
    UserToken.instance.get_number_of_tokens.should == count + 1

  end

  it 'should returns a token already created and don''t store it'  do

    open('tokens.csv', 'w') do |file|
      file.write "abcd1234,user00000003,table00000004,RW\n"
      file.close
    end

    count = UserToken.instance.get_number_of_tokens

    UserToken.instance.generate_token(dataset, permission, @user.username).should == "abcd1234"
    UserToken.instance.get_number_of_tokens.should eq 1

  end

  it 'should checks if the token is valid'  do

    File.should_receive(:open).and_return(StringIO.new(content))
    UserToken.instance.is_valid?(token, @user.username, dataset).should be_true

  end

  it 'should checks the permissions of token'  do

    File.should_receive(:open).and_return(StringIO.new(content))
    UserToken.instance.check_permission(token, @user.username, dataset, permission).should be_true

  end

end
