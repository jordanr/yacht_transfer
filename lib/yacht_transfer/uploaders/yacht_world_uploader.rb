module Js2Fbjs
  module Uploaders
    class YachtWorldUploader < BaseUploader
      def initialize(u, p)
	super(u, p)
	agent.auth(u, p)
      end

      def base_url
        "https://www.boatwizard.com"
      end

      def login_path
        "/boatwizard/listings/edit_listing.cgi?" +
        "action=Add&number=&url=#{username}&pass_office_id=&pass_broker_id=&lang=en"
      end
      
      def login
        begin
          agent.get(base_url+login_path)
 	rescue WWW::Mechanize::ResponseCodeError
	  raise LoginFailedError, "basic authentication failed"
	end
	@logged_on = true
      end
    end
  end
end
