require_relative '../../../spec_helper'

require 'rspec/mocks'
require 'rspec/mocks/standalone'

describe Carto::Api::UserTokensController do
  describe '#show legacy tests' do

    before(:all) do
      @user = FactoryGirl.create(:valid_user)
    end

    before(:each) do
      delete_user_data @user
      @table = create_table(user_id: @user.id)
    end

    after(:all) do
      @user.destroy
    end

    let(:params) { { api_key: @user.api_key, table_id: @table.name, user_domain: @user.username, permissions: "RW" } }

    it "Create a new token" do

      payload = {
          name: "Name 123",
          description: "The description"
      }

      post_json api_v1_tables_user_tokens_create_url(params.merge(payload)) do |response|
        response.status.should be_success
        response.body[:token].should_not be_nil
        response.body[:token].should match(/\A[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}\z/i)
      end
    end
  end
end