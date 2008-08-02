require 'rubygems'
require 'mechanize'
require 'yacht_transfer/service'

module YachtTransfer
  module Services
    class YachtCouncil
      include Service

      def initialize
	@agent = WWW::Mechanize.new
      end

      def session_get(params)
	page = @agent.post(session_get_url, session_get_params!(params))
	return (page.title == 'Home')
      end

      def listings_get(params={})
	page = @agent.get(listings_get_url)
	form = page.forms[1]
	form['LPP']=MAX_LPP
	form['onlymy']=1
	page = form.submit
	page.root.to_html
      end
	
      private
        MAX_LPP = 999

	def base_url
	 'http://www.yachtcouncil.org'
        end
        def session_get_url
          "#{base_url}/login.asp"
        end
	def listings_get_url
	  "#{base_url}/vessel_list.asp"
        end

        def session_get_params!(params)
	  params.merge!({:login=>params.delete(:username)}) if params.has_key?(:username)
        end

        def listings_get_params!(params)
	  params.merge!({:lpp=>MAX_LPP, :onlymy=>1})
        end
    end
  end
end
