require 'yacht_transfer/transferers/abstract_transferer'
module YachtTransfer
  module Transferers
    class YachtWorldTransferer
      include AbstractTransferer
      def initialize(u, p)
	super(u, p)
	agent.auth(u, p)
      end

      def create(listing)
	  post_it_all(listing, nil)
      end

      def update(listing, id)
  	  raise BadIdError, "need an id" if(!id)	  
	  post_it_all(listing, id)
      end
      
      def delete(id)
  	  raise BadIdError, "need an id" if(!id)	  
	  agent.get(delete_url(id))
      end

      def post_it_all(listing, id)
	old_id = id
	id = basic(listing, id)
	raise BadIdError, "edited listing has different id than expected!" if(old_id && id!=old_id)
	details(listing, id)
	photo(listing, id)
	id
      end

      def base_url
        "https://www.boatwizard.com"
      end

      def start_url; base_url+start_path; end
      def basic_url; base_url+basic_path; end
      def details_url; base_url+details_path; end
      def photo_url(id, n); base_url+photo_path+"?"+photo_params(id, n, "Add"); end
      def delete_photo_url(id, n); base_url+delete_photo_path+"?"+photo_params(id, n,"Delete"); end
      def delete_url(id); base_url+delete_path+"?"+delete_params(id); end

      def start_path; "/boatwizard/listings/edit_listing.cgi"; end
      def basic_path; "/boatwizard/lib/edit_sql.cgi"; end
      def details_path; "/boatwizard/lib/edit2_sql.cgi"; end
      def photo_path; "/boatwizard/listings/upload_photo.cgi"; end
      def delete_photo_path; "/boatwizard/listings/photos.cgi"; end
      def delete_path; "/boatwizard/lib/delete_sql.cgi"; end

      def photo_params(id, n, action)
	"boat_id=#{id}&photo=#{n}&url=#{username}&action=#{action}&pass_office_id=&pass_broker_id=&lang=en"
      end

      def delete_params(id)
	"boat_id=#{id}&url=#{username}&lang=en&pass_office_id=&pass_broker_id=&type=All&min_length=&max_length=&units=Feet"
      end

      def login
        begin
          agent.get(base_url)
 	rescue WWW::Mechanize::ResponseCodeError
	  raise LoginFailedError, "basic authentication failed"
	end
	@logged_on = true
      end

      def start(listing)
	agent.post(start_url, yw_start_params(listing))	
      end
      # returns id 
      def basic(listing, id)
	res = agent.post(basic_url, yw_basic_params(listing, id))	
	old_id = id
	id = res.form(:action=>details_path).boat_id
	raise BadIdError, "edited listing has different id than expected!" if(old_id && id!=old_id)
	id
      end

      def details(listing, id)
	raise BadIdError, "need an id" if(!id)
	yacht = listing.yacht
	res = (res and res.form(:action=>details_path).boat_id) ? agent.current_page : add_accommodation(id)
	clob_ids = get_clob_ids(res)
	if(yacht.accommodations.length > clob_ids.length)
	  add_accommodation(id)
	  details(listing, id)
	else
  	  agent.post(details_url, yw_details_params(listing, id, clob_ids))
	end
      end

      def photo(listing, id)
	raise BadIdError, "need an id" if(!id)
	n = 1
	yacht = listing.yacht
	# only can do some max photos at a time
	yacht.pictures.each_slice(YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME) { |pics|
   	  agent.post_files(photo_url(id, n), yw_photo_params(listing, id, n))
	  n+=YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME
	}
	pics_num = get_photo_num(agent.current_page)
	((yacht.pictures.length+1)..pics_num).each { |p| delete_photo(id, p) } # delete extra pics
	basic_with_photo(listing, id)
      end

#      private
        def basic_with_photo(listing, id)
  	  raise BadIdError, "need an id" if(!id)
          # puts yw_basic_with_photo_params
	  agent.post(basic_url, yw_basic_with_photo_params(listing, id) )
        end	

	def delete_photo(id, n)
	  agent.get(delete_photo_url(id, n))
	end

        def add_accommodation(id)
  	  agent.post(details_url, yw_add_accommodation_params(id))
        end 

        # Pre : Parameter is response from calling basic()
        def get_clob_ids(details_page)
	  get_input_values(details_page, "clob_id_")
        end

        def get_photo_num(basic_page)
	  get_input_values(basic_page, "photo_sort_order_").length
        end
	
	def get_input_values(page, input_name)
          inputs = page.parser/"input"
          values = inputs.collect do |i|  
  	    (i.to_html.match(/#{input_name}/)) ? i['value'] : nil
  	  end
          values.compact!
	end
	
    end
  end
end

class Array
  def each_slice(n, &block)
    i = 0
    while(i<length)
      yield slice(i...i+n)
      i +=n
    end
  end

  def except(n)
    slice(0...n)+slice((n+1)...length)
  end
end
	
# [232,333,1,94,85,3].each_slice(2) { |a| puts a }
#[232,333,1,94,85,3].except(4)

