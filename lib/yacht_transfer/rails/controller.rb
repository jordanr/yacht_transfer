require 'yacht_transfer'     
module Facebooker
  module Rails
    module Controller
      def yacht_council_session(uname, pass, listing)
	YachtCouncilUploader.new(uname, pass, listing)	
      end

      def yacht_world_session(uname, pass, listing)
	YachtWorldUploader.new(uname, pass, listing)	
      end
    end
  end
end
