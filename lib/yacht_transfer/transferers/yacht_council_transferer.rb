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

      def update(listing, id)
        raise BadIdError, "need an id" if(!id)
        listing = YachtTransfer::Standards::YachtCouncilHash.new(listing)
        post_it_all(listing, id)
      end

      def destroy(id)
        raise BadIdError, "need an id" if(!id)
        #get(delete_url(id))
        nil
      end

      ########################
      # URI's
      ################
      def base_url; "http://www.yachtcouncil.org"; end
      def login_url; base_url+login_path; end
      def home_url; base_url+home_path; end
      def basic_url; base_url+basic_path; end
      def photo_url; base_url+photo_path; end

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
#        photo(listing.photo)
        id
      end
      #################
      # Helpers
      #################

      # create photos
      def photo(params)
        multipart_post(photo_url, params)
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
        res['location'].split("=").last if res['location'].to_i
      end

      def agent(host, port)
        return @agent if @agent
        http = Net::HTTP.new(host, port)
        http.set_debug_output $stdout
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

    end
  end
end
