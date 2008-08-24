require 'yacht_transfer'     
module Facebooker
  module Rails
    module Controller
      def yacht_council_session(uname, pass)
	YachtCouncilUploader.new(uname, pass)	
      end

      def yacht_world_session
	YachtWorldUploader.new(uname, pass)	
      end
    end
  end
end
