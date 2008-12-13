require 'yacht_transfer/uploaders/base_uploader'
module YachtTransfer
  module Uploaders
    class YachtWorldUploader < BaseUploader
      def initialize(u, p, l, id=nil)
	super(u, p, l, id)
	agent.auth(u, p)
      end


      def create
  	  id = nil if(id)
	  post_it_all
      end

      def update
  	  raise BadIdError, "need an id" if(!id)	  
	  post_it_all
      end
      
      def delete
  	  raise BadIdError, "need an id" if(!id)	  
	  agent.get(delete_url)
      end

      def post_it_all
	basic
	details
	photo
      end

      def base_url
        "https://www.boatwizard.com"
      end

      def start_url; base_url+start_path; end
      def basic_url; base_url+basic_path; end
      def details_url; base_url+details_path; end
      def photo_url(n); base_url+photo_path+"?"+photo_params(n, "Add"); end
      def delete_photo_url(n); base_url+delete_photo_path+"?"+photo_params(n,"Delete"); end
      def delete_url; base_url+delete_path+"?"+delete_params; end

      def start_path; "/boatwizard/listings/edit_listing.cgi"; end
      def basic_path; "/boatwizard/lib/edit_sql.cgi"; end
      def details_path; "/boatwizard/lib/edit2_sql.cgi"; end
      def photo_path; "/boatwizard/listings/upload_photo.cgi"; end
      def delete_photo_path; "/boatwizard/listings/photos.cgi"; end
      def delete_path; "/boatwizard/lib/delete_sql.cgi"; end

      def photo_params(n, action)
	"boat_id=#{id}&photo=#{n}&url=#{username}&action=#{action}&pass_office_id=&pass_broker_id=&lang=en"
      end

      def delete_params
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

      def photo
	raise BadIdError, "need an id" if(!id)
	n = 1
	# only can do some max photos at a time
	yacht.pictures.each_slice(YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME) { |pics|
   	  agent.post_files(photo_url(n), yw_photo_params(n))
	  n+=YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME
	}
	pics_num = get_photo_num(agent.current_page)
	((yacht.pictures.length+1)..pics_num).each { |p| delete_photo(p) } # delete extra pics
	basic_with_photo
      end

#      private
        def basic_with_photo
  	  raise BadIdError, "need an id" if(!id)
          # puts yw_basic_with_photo_params
	  agent.post(basic_url, yw_basic_with_photo_params)
        end	

	def delete_photo(n)
	  agent.get(delete_photo_url(n))
	end

        def add_accommodation
  	  agent.post(details_url, yw_add_accommodation_params)
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

