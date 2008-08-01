require 'yacht_transfer/model'

module YachtTransfer
  module Models
    class Listing
      include Model
  
      FIELDS = [:lid, :broker, :type, :status]
      poppulating_attr_accessor *FIELDS
      populating_hash_settable_accessor :price, Measurement
      populating_hash_settable_accessor :yacht, Yacht

      def populate!
      end
    end
  end
end

