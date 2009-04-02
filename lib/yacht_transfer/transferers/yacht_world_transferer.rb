require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/standards/yacht_world_standards'
module YachtTransfer
  module Transferers
    class YachtWorldTransferer
      include AbstractTransferer

      #################
      # Public interface
      ###############

      def authentic?
  	 res = get(login_url)
         res.is_a?(Net::HTTPSuccess)
      end

      def create(listing)
	  listing = YachtTransfer::Standards::YachtWorldHash.new(listing)
	  post_it_all(listing, nil)
      end

      def update(listing, id)
  	  raise BadIdError, "need an id" if(!id)	  
	  listing = YachtTransfer::Standards::YachtWorldHash.new(listing)
	  post_it_all(listing, id)
      end
      
      def delete(id)
  	  raise BadIdError, "need an id" if(!id)	  
	  get(delete_url(id))
	  id
      end

      ########################
      # URI's 
      ################
      def login_url; base_url + login_path; end
      def base_url; "https://www.boatwizard.com"; end
      def basic_url; base_url+basic_path; end
      def details_url; base_url+details_path; end
      def upload_photo_url(id, n); base_url+upload_photo_path+"?"+photo_params(id, n, "Add"); end
      def photo_url(id, n); base_url+photo_path+"?"+photo_params(id, n, "Add"); end
      def delete_photo_url(id, n); base_url+delete_photo_path+"?"+photo_params(id, n,"Delete"); end

      # listing
      def delete_url(id); base_url+delete_path+"?"+delete_params(id); end
      def delete_params(id); "boat_id=#{id}&url=#{username}&lang=en&pass_office_id=&pass_broker_id=&type=All&min_length=&max_length=&units=Feet"; end

      def login_path; "/index.cgi"; end
      def basic_path; "/boatwizard/lib/edit_sql.cgi"; end
      def details_path; "/boatwizard/lib/edit2_sql.cgi"; end
      def upload_photo_path; "/boatwizard/listings/upload_photo.cgi"; end
      def photo_path; "/boatwizard/listings/photos.cgi"; end
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
	raise BadIdError, "id should be #{old_id} but was #{id}" if(old_id && id!=old_id)
        if !old_id
  	  listing.merge!(:id => id)
          listing.to_yw!
        end

	details(listing.details)
	photo(listing.photo, id)
	id
      end

      ###########################
      # Listing, Details
      ##############################

      # Create Update listing
      # returns id 
      def basic(params)
	res = post(basic_url, params) #yw_basic_paramslisting, id))
	res = res.body
        #<INPUT type="hidden" name="boat_id" value="1966820">
	id = res.slice(/.*<INPUT type="hidden" name="boat_id" value="([0-9]+)">.*/, 0)
	id.gsub!(/.*<INPUT type="hidden" name="boat_id" value="([0-9]+)">.*/, '\1') if id

	id.to_i
      end


      # update, destroy details
      # update listing
      #
      # Pre: id is included in params
      def details(params)
	post(details_url, params) #yw_details_params(listing, id, clob_ids))

#	res = (res and res.form(:action=>details_path).boat_id) ? current_page : add_accommodation(id)
#	clob_ids = get_clob_ids(res)
#        clob_ids =[]
#	if(yacht.accommodations.length > clob_ids.length)
#	  add_accommodation(id)
#	  details(listing, id)
#	else
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
      def photo(params_list, id)
	nums = params_list.keys.sort
        nums.each do |n|
          multipart_post(upload_photo_url(id, n), params_list[n])
#          multipart_post(photo_url(id, n), params_list[n], { "referer" =>upload_photo_url(id, n) })
#          get(photo_url(id, n))
        end

#	pics_num = get_photo_num(current_page)
#	((yacht.pictures.length+1)..pics_num).each { |p| delete_photo(id, p) } # delete extra pics
#	basic_with_photo(listing, id)
      end

      # Delete photos
      def delete_photo(id, n)
        get(delete_photo_url(id, n))
	id
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
	return @agent if @agent
        http = Net::HTTP.new(host, port)
        http.set_debug_output $stderr
        http.use_ssl = true          
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def request(path, method, headers=nil)
        if method == :get
          req = Net::HTTP::Get.new(path)
        elsif method == :post
          req = Net::HTTP::Post.new(path)
        else
          raise ArgumentError("unknown method")
        end
        req.basic_auth username, password
        headers.each_pair { |k, v| req.add_field(k, v) } if headers
#        req.add_field('Accept-Encoding', 'gzip,identity')
        req.add_field('Accept-Language', 'en-us,en;q=0.5')
#        req.add_field('Host', uri.host)
        req.add_field('Accept-Charset', 'ISO-8859-1,utf-8;q=0.7,*;q=0.7')
        req.add_field('Connection', 'keep-alive')
        req.add_field('Keep-Alive', '300')


#	req.each_header { |k, v| print k; print v; }
#	raise
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

