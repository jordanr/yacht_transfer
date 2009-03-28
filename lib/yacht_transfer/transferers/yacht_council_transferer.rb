require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/standards/yacht_council_standards'
module YachtTransfer
  module Transferers
    class YachtCouncilTransferer
      include AbstractTransferer, YachtTransfer::Standards::YachtCouncilStandards

      def initialize(uname, pass)
	@username = uname
	@password = pass
	@cookie_jar = nil
      end

      def base_url; "http://www.yachtcouncil.org"; end
      
      def login_url; base_url+login_path; end
      def home_url; base_url+home_path; end
      def basic_url; base_url+basic_path; end

      def login_path; "/login.asp?login=#{username}&password=#{password}"; end
      def home_path; "/company_home.asp"; end
      def basic_path; "/vessel_entry_step1.asp"; end

      def authentic?
        res = get(login_url)
        return false if ! res['location']
	
	#  otherwise follow the redirect	
	@cookie_jar = CGI::Cookie::parse(res['set-cookie'])
#	@cookie_jar = res['set-cookie']
	res = get(home_url, {'Referer' => login_url} )
	res.body.match(/Logoff/)
      end

      # returns id
      def basic(listing, id)
        res = agent.post(basic_url, yc_basic_params(listing, id))
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

        if ! @cookie_jar.nil?
	  cookies = []
	  @cookie_jar.each_pair { |key, value|
	    cookies += ["#{key}=#{value.first}"]
	  }
  	  req.add_field('Cookie', cookies.join(";"))
        end

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
