require 'yacht_transfer/transferers/abstract_transferer'
module YachtTransfer
  module Transferers
    class YachtCouncilTransferer
      include AbstractTransferer
      def base_url
        "http://www.yachtcouncil.org"
      end

      def login_path
        "/login.asp?login=#{username}&password=#{password}"
      end

      def login
        agent.get(base_url+login_path)
	raise LoginFailedError, "login failed" unless page.body.match(/Logoff/)
	@logged_on = true
      end
    end
  end
end
