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
      def photo_url(n); base_url+photo_path+"?"+photo_params(n); end

      def start_path; "/boatwizard/listings/edit_listing.cgi"; end
      def basic_path; "/boatwizard/lib/edit_sql.cgi"; end
      def details_path; "/boatwizard/lib/edit2_sql.cgi"; end
      def photo_path; "/boatwizard/listings/upload_photo.cgi"; end
      def photo_params(n);"boat_id=#{id}&photo=#{n}&url=#{username}&action=Add&pass_office_id=&pass_broker_id=&lang=en";end

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

      def details
	raise BadIdError, "need an id" if(!id)
	res = (res and res.form(:action=>details_path).boat_id) ? agent.current_page : add_accommodation
	clob_ids = get_clob_ids(res)
	if(yacht.accommodations.length > clob_ids.length)
	  add_accommodation
	  details
	else
  	  agent.post(details_url, yw_details_params(clob_ids))
	end
      end

      def photo(n)
	raise BadIdError, "need an id" if(!id)
  	agent.post_files(photo_url(n), yw_photo_params(n))
      end

      private
        def add_accommodation
  	  agent.post(details_url, yw_add_accommodation_params)
        end 

        # Pre : Parameter is response from calling basic()
        def get_clob_ids(details_page)
          inputs = details_page.parser/"input"
          clob_ids = inputs.collect do |i|  
  	    (i.to_html.match(/clob_id_/)) ? i['value'] : nil
  	  end
          clob_ids.compact!
        end
    end
  end
end
