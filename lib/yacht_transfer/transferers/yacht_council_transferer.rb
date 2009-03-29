require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/standards/yacht_council_standards'
module YachtTransfer
  module Transferers
    class UnauthorizedError < StandardError; end

    class YachtCouncilTransferer
      include AbstractTransferer

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

      def delete(id)
        raise BadIdError, "need an id" if(!id)
        #get(delete_url(id))
        id
      end

      ########################
      # URI's
      ################
      def base_url; "http://www.yachtcouncil.org"; end
      def login_url; base_url+login_path; end
      def home_url; base_url+home_path; end
      def basic_url; base_url+basic_path; end

      def login_path; "/login.asp?login=#{username}&password=#{password}"; end
      def home_path; "/company_home.asp"; end
      def basic_path; "/vessel_entry_step1.asp"; end


      ######################
      # Main                 
      ##################
      def post_it_all(listing, id)
#        listing.merge!(:username => username)
#        listing.merge!(:id => id ? id : "New")

        listing.to_yc! 
        old_id = id     
        id = basic(listing.basic)              
        raise BadIdError, "id should be #{old_id} but was #{id}" if(old_id && id!=old_id)
#        if !old_id
#          listing.merge!(:id => id)              
#          listing.to_yc!
#        end

#        details(listing.details)
 #       photo(listing.photo, id)
        id
      end


      #################
      # Helpers
      #################
	
      def authenticate 
        @cookie_jar = {}
        res = get(login_url)
	raise UnauthorizedError unless res['location']

	#  otherwise follow the redirect	
	@cookie_jar = CGI::Cookie::parse(res['set-cookie'])
	res = get(home_url, {'Referer' => login_url} )
	res.body.match(/Logoff/)
      end

      # returns id
      def basic(params)
        res = post(basic_url, params)
#        old_id = id
 #       id = res.form(:action=>details_path).boat_id
  #      raise BadIdError, "edited listing has different id than expected!" if(old_id && id!=old_id)
   #     id
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
	  cookies += ["#{key}=#{value.first}"]
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
