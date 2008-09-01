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

      def start_path
        "/boatwizard/listings/edit_listing.cgi" 
#        "action=Add&number=&url=#{username}&pass_office_id=&pass_broker_id=&lang=en"
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
	agent.post(base_url+start_path, yw_start_params)	
      end

      def basic
	agent.post(base_url+basic_path, yw_basic_params)	
      end
    end
  end
end
