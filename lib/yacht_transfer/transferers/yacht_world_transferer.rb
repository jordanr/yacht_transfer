require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/standards/yacht_world_standards'
module YachtTransfer
  module Transferers
    class YachtWorldTransferer
      include AbstractTransferer, YachtTransfer::Standards::YachtWorldStandards

      #################
      # Public interface
      ###############

      def authentic?
        http=Net::HTTP.new(base_url, 443)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Get.new('/')
        req.basic_auth username, password
        begin
          response = http.request(req)
        rescue
	  return false
        else
	  return true
        end
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
	  get(delete_url(id))
      end


      ##########################
      # private
      #########################


       

      ########################
      # URI's 
      ################
      def base_url; "https://www.boatwizard.com"; end
      def basic_url; base_url+basic_path; end
      def details_url; base_url+details_path; end
      def photo_url(id, n); base_url+photo_path+"?"+photo_params(id, n, "Add"); end
      def delete_photo_url(id, n); base_url+delete_photo_path+"?"+photo_params(id, n,"Delete"); end

      # listing
      def delete_url(id); base_url+delete_path+"?"+delete_params(id); end
      def delete_params(id); "boat_id=#{id}&url=#{username}&lang=en&pass_office_id=&pass_broker_id=&type=All&min_length=&max_length=&units=Feet"; end

      def basic_path; "/boatwizard/lib/edit_sql.cgi"; end
      def details_path; "/boatwizard/lib/edit2_sql.cgi"; end
      def photo_path; "/boatwizard/listings/upload_photo.cgi"; end
      def delete_photo_path; "/boatwizard/listings/photos.cgi"; end
      def delete_path; "/boatwizard/lib/delete_sql.cgi"; end
      def photo_params(id, n, action); "boat_id=#{id}&photo=#{n}&url=#{username}&action=#{action}&pass_office_id=&pass_broker_id=&lang=en"; end


      ######################
      # Main
      ##################
      def post_it_all(listing, id)
	listing.merge!(:username => username)
	listing.merge!(:id => id ? id : "New")

        listing.to_yw!
	old_id = id
	id = basic(listing.basic)
	raise BadIdError, "edited listing has different id than expected!" if(old_id && id!=old_id)
        if !old_id
  	  listing.merge!(:id => id)
          listing.to_yw!
        end

	details(listing.details)
#	photo(listing.photo)
	id
      end

      ###########################
      # Listing, Details
      ##############################

      # Create Update listing
      # returns id 
      def basic(params)
	res = post(basic_url, params) #yw_basic_paramslisting, id))
#	old_id = #
	id = res
#	id = res.form(:action=>details_path).boat_id
#	raise BadIdError, "edited listing has different id than expected!" if(old_id && id!=old_id)
	id
      end


      # update, destroy details
      # update listing
      def details(params)
#	raise BadIdError, "need an id" if(!id)
#	yacht = listing.yacht
#	res = (res and res.form(:action=>details_path).boat_id) ? current_page : add_accommodation(id)
#	clob_ids = get_clob_ids(res)
#        clob_ids =[]
#	if(yacht.accommodations.length > clob_ids.length)
#	  add_accommodation(id)
#	  details(listing, id)
#	else
	post(details_url, params) #yw_details_params(listing, id, clob_ids))
#	end
      end

      # create detail
      def add_accommodation(params)
  	  post(details_url, params) #yw_add_accommodation_params(id))
      end 


      ############################
      # Photos
      #####################          

      # create photos
      def photo(params)
#	raise BadIdError, "need an id" if(!id)
	n = 1
#	yacht = listing.yacht
	# only can do some max photos at a time
#	yacht.pictures.each_slice(YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME) { |pics|
#   	  post_files(photo_url(id, n), yw_photo_params(listing, id, n))
#	  n+=YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME
#	}
#	pics_num = get_photo_num(current_page)
#	((yacht.pictures.length+1)..pics_num).each { |p| delete_photo(id, p) } # delete extra pics
#	basic_with_photo(listing, id)
      end

      # Delete photos
      def delete_photo(id, n)
        get(delete_photo_url(id, n))
      end

      # Update photos
      def basic_with_photo(listing, id)
	raise BadIdError, "need an id" if(!id)
        # puts yw_basic_with_photo_params
	post(basic_url, yw_basic_with_photo_params(listing, id) )
      end	


      ###################################33
      # Helpers
      ########################

      def agent(host, port)
        http = Net::HTTP.new(host, port)
#        http.set_debug_output $stderr
        http.use_ssl = true          
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def request(path, method, initheader=nil)
        if method == :get
          req = Net::HTTP::Get.new(path, initheader)
        elsif method == :post
          req = Net::HTTP::Post.new(path, initheader)
        else
          raise ArgumentError "unknown method"
        end
        req.basic_auth username, password
	req
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
    (length == 0) ? [] : slice(0...n)+slice((n+1)...length)
  end
end
	
# [232,333,1,94,85,3].each_slice(2) { |a| puts a }
#[232,333,1,94,85,3].except(4)

