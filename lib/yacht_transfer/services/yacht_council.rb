require 'rubygems'
require 'mechanize'
require 'yacht_transfer/service'

module YachtTransfer
  module Services
    class YachtCouncil
      include Service

      def self.session_get(params)
	agent = WWW::Mechanize.new
	page = agent.post(self.login_url, self.convert_to_yc!(params))
	if(page.title=='Home')
	  agent
	else
	  nil
	end
      end

      private
        def self.login_url
          'http://www.yachtcouncil.org/login.asp'
        end

        def self.convert_to_yc!(params)
	  params.merge!({:login=>params.delete(:username)}) if params.has_key?(:username)
        end
    end
  end
end
