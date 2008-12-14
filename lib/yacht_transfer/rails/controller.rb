require 'yacht_transfer/transferers/yacht_council_transferer'     
require 'yacht_transfer/transferers/yacht_world_transferer'     
module YachtTransfer
  module Rails
    module Controller
      def yacht_council_session(uname, pass, listing)
	YachtCouncilTransferer.new(uname, pass, listing)	
      end

      def yacht_world_session(uname, pass, listing)
	YachtWorldTransferer.new(uname, pass, listing)	
      end
    end
  end
end
