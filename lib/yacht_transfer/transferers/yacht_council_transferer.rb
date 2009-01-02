require 'yacht_transfer/transferers/abstract_transferer'
require 'yacht_transfer/standards/yacht_council_standards'
module YachtTransfer
  module Transferers
    class YachtCouncilTransferer
      include AbstractTransferer, YachtTransfer::Standards::YachtCouncilStandards

      def base_url; "http://www.yachtcouncil.org"; end
      
      def login_url; base_url+login_path; end
      def basic_url; base_url+basic_path; end

      def login_path; "/login.asp?login=#{username}&password=#{password}"; end
      def basic_path; "/vessel_entry_step1.asp"; end

      def login
        agent.get(login_url)
	raise LoginFailedError, "login failed" unless page.body.match(/Logoff/)
	@logged_on = true
      end

      # returns id
      def basic(listing, id)
        res = agent.post(basic_url, yc_basic_params(listing, id))
#        old_id = id
 #       id = res.form(:action=>details_path).boat_id
  #      raise BadIdError, "edited listing has different id than expected!" if(old_id && id!=old_id)
   #     id
      end
    end
  end
end
