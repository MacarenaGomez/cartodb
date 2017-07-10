# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require_relative '../../../models/carto/permission'

module Carto
  module Api
    class UserTokensController < ::Api::ApplicationController
      ssl_required :create

      REJECT_PARAMS = %w{ format controller action row_id requestId column_id
                          api_key table_id oauth_token oauth_token_secret user_domain permissions}.freeze

      before_filter :generate_token, only: [:create]

      def create
        render_jsonp(eval(@token).to_json)
      rescue => e
        render_jsonp({ errors: [e.message] }, 400)
      end

      protected

      def filtered_row
        params.reject { |k, _| REJECT_PARAMS.include?(k) }.symbolize_keys
      end

      def generate_token
        @token = UserToken.instance.generate_token(params[:table_id], params[:permissions], current_user.username)
        raise RecordNotFound unless @token
      end
    end
  end
end