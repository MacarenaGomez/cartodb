# encoding: utf-8

require 'securerandom'
require 'singleton'

class UserToken
	include Singleton

	FILE_NAME = 'tokens.csv'

  def initialize
    File.open(FILE_NAME,'wb')
  end

	def generate_token(dataset, permission, username)
    table_name = ::Table.table_and_schema(dataset)

    if !table_name.nil?
      token = get_token_line('', dataset, permission, username)[0]
      if token.nil?
        token = SecureRandom.uuid
        new_line = token + ',' + username + ',' + dataset + ',' + permission + "\n"
        open(FILE_NAME, 'w') do |file|
          file.write new_line
          file.close
        end
      end
      token
    end
	end

	def is_valid?(token, username, dataset)
    get_token_line(token, username, dataset, '').size > 0
	end

	def check_permission(token, username, dataset, permission)
    get_token_line(token, username, dataset, permission)[-1].include? permission
  end

  def get_number_of_tokens
    count = 0
    count = %x{wc -l < "#{FILE_NAME}"}.to_i
  end

	private

	def get_token_line(token, username, dataset, permission)
    l = File.open(FILE_NAME) do |file|
       file.find { |line| line =~ /token + ',' + username + ',' + dataset + ',' + permission/}
    end
    l = (l.nil?)? [] : l.string.split(',')
  end

end