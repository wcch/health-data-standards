require 'rest_client'
require 'uri'
module HealthDataStandards
  module Util
		class VSApi			
			attr_accessor :api_url, :ticket_url,  :username, :password

			def initialize(ticket_url, api_url,username,password)
				@api_url = api_url
				@ticket_url = ticket_url
				@username = username
				@password = password
			end

			def get_valueset(oid,&block)
				vs = RestClient.get api_url, {:params=>{id: oid, ticket: get_ticket}}
				yield oid,vs if block_given?
				vs
			end

			def process_valuesets(oids, &block)
				oids.each do |oid|
		     		vs = get_valueset(oid)
		     		yield oid,vs
				end
			end

			def proxy_ticket
			 	@proxy_ticket ||= get_proxy_ticket
			end

			def get_proxy_ticket
				# the content type is set and the body is a string becuase the NLM service does not support urlencoded content and
				# throws an error on that contnet type
				 RestClient.post ticket_url, {username: username, password: password}
			end
			
			def get_ticket
			  RestClient.post "#{ticket_url}/#{proxy_ticket}", {service: "http://umlsks.nlm.nih.gov"}
		  end
		end
  end
end
