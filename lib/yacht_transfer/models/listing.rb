require 'yacht_transfer/model'
require 'yacht_transfer/models/measurement'
require 'yacht_transfer/models/yacht'

module YachtTransfer
  module Models
    class Listing
      include Model
  
      FIELDS = [:yc_id, :yw_id, :broker, :type, :status]
      populating_attr_accessor *FIELDS
      populating_hash_settable_accessor :price, Measurement
      populating_hash_settable_accessor :yacht, Yacht

      def populate!
      end
    end
  end
end

