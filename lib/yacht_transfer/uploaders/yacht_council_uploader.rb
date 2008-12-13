module YachtTransfer
  module Uploaders
    class YachtCouncilUploader < BaseUploader
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
