module Js2Fbjs
  module Uploaders
    class YachtWorldUploader < BaseUploader
      def initialize(u, p, l, id=nil)
	super(u, p, l, id)
	agent.auth(u, p)
      end

      def base_url
        "https://www.boatwizard.com"
      end

      def start_url; base_url+start_path; end
      def basic_url; base_url+basic_path; end
      def details_url; base_url+details_path; end
      def start_path; "/boatwizard/listings/edit_listing.cgi"; end
      def basic_path; "/boatwizard/lib/edit_sql.cgi"; end
      def details_path; "/boatwizard/lib/edit2_sql.cgi"; end

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
	res = agent.post(basic_url, yw_basic_params)	
	old_id = @id
	@id = res.form(:action=>details_path).boat_id
	raise BadIdError, "edited listing has different id than expected!" if(old_id && @id!=old_id)
	res
      end

      def details(page)
	res = page # agent.current_page # just called basic
	if(res and res.form(:action=>details_path).boat_id)
          inputs = res.parser/"input"
          clob_ids =inputs.collect { |i| if(i.to_html.match(/clob_id_/))
                         i['value']
                       else
                         nil
                       end
                 }
          clob_ids.compact!
	else
	  raise StandardError
	end
	  
	agent.post(details_url, yw_details_params(clob_ids))
      end
    end
  end
end
