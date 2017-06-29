# encoding: utf-8
require 'SecureRandom'
require 'singleton'

class UserToken
	include Singleton

	FILE_NAME = 'tokens.csv'

	#Esto no lo piden
	def generate_token(dataset, permission)
    token = get_token_line('', dataset, permission).first
		if token.nil?
			token = SecureRandom.uuid
			new_line = token + ';' + current_user + ';' + dataset + ';' + permission 

			File.open(target, "w+") do |f|
	  			f.write(new_line)	
	  		end	
		end
		token
	end

	def is_valid?(token, dataset)
		return get_token_line(token, dataset, '').size > 0
	end

	def check_permission?(token, dataset, permission)
	  return get_token_line(token, dataset, permission).last.upcase == permission
	end

	private

	def get_token_line(token, dataset, permission)
		return File.foreach(FILE_NAME).grep(token + ';' + current_user + ';' + dataset + ';' + permission)[0].split(';')
	end

end 