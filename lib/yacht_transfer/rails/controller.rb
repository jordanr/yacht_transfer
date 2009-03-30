require 'yacht_transfer/transferers/yacht_council_transferer'     
require 'yacht_transfer/transferers/yacht_world_transferer'     
module YachtTransfer
  module Rails
    module Controller
      def yacht_council_session(uname, pass)
	YachtCouncilTransferer.new(uname, pass)	
      end

      def yacht_world_session(uname, pass)
	YachtWorldTransferer.new(uname, pass)	
      end
    end
  end
end
