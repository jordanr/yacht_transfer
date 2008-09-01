module Js2Fbjs
  module Uploaders
    class YachtWorldUploader < BaseUploader
      def initialize(u, p, l)
	super(u, p, l)
	agent.auth(u, p)
      end

      def base_url
        "https://www.boatwizard.com"
      end

      def start_url; base_url+start_path; end
      def basic_url; base_url+basic_path; end

      def start_path
        "/boatwizard/listings/edit_listing.cgi" 
      end
      def basic_path
        "/boatwizard/lib/edit_sql.cgi"
      end

      def login
        begin
          agent.get(base_url)
 	rescue WWW::Mechanize::ResponseCodeError
	  raise LoginFailedError, "basic authentication failed"
	end
	@logged_on = true
      end

      def start
	agent.post(start_url, yw_start_params)	
      end

      def basic
	agent.post(basic_url, yw_basic_params)	
      end
    end
  end
end
