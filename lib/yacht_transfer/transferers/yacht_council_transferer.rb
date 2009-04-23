require 'iconv'
require 'cookie'
require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/standards/yacht_council_standards'
module YachtTransfer
  module Transferers
    class UnauthorizedError < StandardError; end

    class YachtCouncilTransferer
      include AbstractTransferer

#      attr_accessor :cookie_jar

      def initialize(uname, pass)
	@username = uname
	@password = pass
	@cookie_jar = nil
      end

      def authentic?
	begin
	  authenticate
	rescue # UnauthorizedError
          return false
	else
	  return true
	end
      end

      def create(listing)
        listing = YachtTransfer::Standards::YachtCouncilHash.new(listing)
        post_it_all(listing, nil)
      end

      def read(id)
        raise BadIdError, "need an id" if(!id)
        authenticate if @cookie_jar.nil?
	res = get(read_url(id))
	Iconv.conv('UTF-8', 'windows-1252', res.body)
      end

      def update(listing, id)
        raise BadIdError, "need an id" if(!id)
        listing = YachtTransfer::Standards::YachtCouncilHash.new(listing)
        post_it_all(listing, id)
      end

      def destroy(id)
        raise BadIdError, "need an id" if(!id)
        old_id = id.to_i
        listing = YachtTransfer::Standards::YachtCouncilHash.new(empty_listing)
        listing.merge!(:id => id)

        authenticate if @cookie_jar.nil?
	listing.merge!({:login_id=>@cookie_jar[:LoginID], :member_company_id=>@cookie_jar[:MemberID]})
	listing.merge!(:broker_id => "0") # zero means deleted

        listing.to_yc! 
        id = basic(listing.basic)
        raise BadIdError, "id should be #{old_id} but was #{id}" if(old_id && id.to_i != old_id.to_i)
        nil
      end

      ########################
      # URI's
      ################
      def base_url; "http://www.yachtcouncil.org"; end

      def public_base_url; "http://www.yachtcouncil.com";end
	
      def read_url(id); public_base_url+read_path(id); end
      def login_url; base_url+login_path; end
      def home_url; base_url+home_path; end
      def basic_url; base_url+basic_path; end
      def photo_url; base_url+photo_path; end

#      def read_path(id); "/vessel_basic_info.asp?vessels_id=#{id}"; end
      def read_path(id); "/media/brochure_generate_1.asp?vessel_id=#{id}&CompanyID=#{@cookie_jar[:MemberID]}&int_login_id=#{@cookie_jar[:LoginID]}&ph=0&full_listing_flag=1&blnPrintPageNumbers=1&blnCoverInlude=0&blnPhotos=0&blnPicInlude=1&blnQuality=1&blnIncludeLogo=1&blnIncludeContact=1&blnUseHFSpace=0&blnOnePage=0&blnLayout=1&blnNoImage=0&MainProfilePhotoOnly=0"; end
      def login_path; "/login.asp?login=#{username}&password=#{password}"; end
      def home_path; "/company_home.asp"; end
      def basic_path; "/vessel_entry_step1.asp"; end
      def photo_path; "/media-uploader.aspx"; end

      ######################
      # Main                 
      ##################
      def post_it_all(listing, id)
#        listing.merge!(:id => id ? id : "0")
        listing.merge!(:id => id) if ! id.nil?

        authenticate if @cookie_jar.nil?

	listing.merge!({:login_id=>@cookie_jar[:LoginID], :member_company_id=>@cookie_jar[:MemberID]})
	listing.merge!(:broker_id => "3910")

        listing.to_yc! 
        old_id = id     
        id = basic(listing.basic)              
        raise BadIdError, "id should be #{old_id} but was #{id}" if(old_id && id!=old_id)
        if !old_id
          listing.merge!(:id => id)              
          listing.to_yc!
        end
#        details(listing.details)
        photo(listing.photo)
        id
      end
      #################
      # Helpers
      #################

      def empty_listing
        {:price=>"1", :yacht_name=>"none",:yacht_specification_manufacturer=>"none",
         :yacht_specification_model=>"none", :yacht_specification_year=>"9999",
         :yacht_specification_length=>"1", :yacht_location=>"none", :photos=>[], :details=>[],
	 :yacht_specification_number_of_engines => "1", :yacht_specification_fuel=>"",
	 :yacht_specification_material=>"", :yacht_specification_designer=>""
        }
      end  

      # create photos
      def photo(param_list)
	ids = nil
	i = 0 
	param_list.each do |params|
	  params.merge!(saved_photos(ids)) if ids

          res = multipart_post(photo_url, params)
          ids = scrape_photos(res.body)

	  i += 1
        end
      end

      def authenticate 
        @cookie_jar = {}
        res = get(login_url)
	raise UnauthorizedError unless res['location']

	@cookie_jar = Cookie::parse(res['set-cookie'])
      end

      # returns id
      def basic(params)
        res = post(basic_url, params)
        res['location'].split("=").last.to_i if res['location']
      end

      def agent(host, port)
        return @agent if @agent
        http = Net::HTTP.new(host, port)
#        http.set_debug_output $stdout
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
#        req.basic_auth username, password
        
  	if headers
          headers.each_pair { |k, v| req.add_field(k, v) } 
	end

	authenticate if @cookie_jar.nil?

	cookies = []
	@cookie_jar.each_pair { |key, value|
	  cookies += ["#{key}=#{value}"]
	}
  	req.add_field('Cookie', cookies.join(";"))

        req.add_field('Accept-Encoding', 'gzip,identity')
        req.add_field('Accept-Language', 'en-us,en;q=0.5')
#        req.add_field('Host', uri.host)
        req.add_field('Accept-Charset', 'ISO-8859-1,utf-8;q=0.7,*;q=0.7')
        req.add_field('Connection', 'keep-alive')
        req.add_field('Keep-Alive', '300')


#       req.each_header { |k, v| print k; print v; }
#       raise
        req                
      end


      private
        def saved_photos(p_hash)
          ans = {}         
          p_hash.each_pair do |n, hassh| 
			ans.merge!({
			"pictures-2editor#{n}id".to_sym => hassh[0],
                        "pictures-2editor#{n}width".to_sym => hassh[1],
                        "pictures-2editor#{n}height".to_sym => hassh[2],
                        "pictures-2editor#{n}description".to_sym => hassh[3],
                        "pictures-2editor#{n}FileName".to_sym => hassh[4]
			})
  	  end
          ans
        end

        def scrape_photos(res)
	  # need to keep track of the old photo info...
	  #<input type="hidden" id="pictures-2editor0id" name="pictures-2editor0id" value="729592">
	  id_needle = /pictures-2editor([0-9]+)id\"[^>]*value=\"([0-9]+)\">/m
	  width_needle = /pictures-2editor([0-9]+)width\"[^>]*value=\"([0-9]+)\">/m
	  height_needle = /pictures-2editor([0-9]+)height\"[^>]*value=\"([0-9]+)\">/m
	  descr_needle = /pictures-2editor([0-9]+)description\"[^>]*value=\"([^\"]*)\">/m
	  fn_needle = /pictures-2editor([0-9]+)FileName\"[^>]*value=\"([^\"]*)\">/m

	  ids = res.scan(id_needle)
	  return nil if ! ids

	  # otherwise get the rest
	  widths = res.scan(width_needle)
	  heights = res.scan(height_needle)
	  descrs = res.scan(descr_needle)
	  fns = res.scan(fn_needle)

	  ans = {}
	  ids.each { |n, id| ans.merge!(n => [id]) }
	
	  # fold in the rest
	  widths.each { |n, w| ans[n] += [w] }
	  heights.each { |n, w| ans[n] += [w] }
	  descrs.each { |n, w| ans[n] += [w] }
	  fns.each { |n, w| ans[n] += [w] }
	  
	  ans
	end
    end
  end
end
