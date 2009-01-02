require 'yacht_transfer/model'
require 'yacht_transfer/models/measurement'
require 'yacht_transfer/models/yacht'
require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Models
    class Listing
      include Model, YachtTransfer::Standards::BaseStandards

      FIELDS = [:broker, :type, :status, :co_op, :contact_info]
      populating_attr_reader *FIELDS
      attr_writer :broker, :co_op, :contact_info
      option_checking_attr_writer :type, listing_types #std::LISTING_TYPE_TRANSFORM.keys
      option_checking_attr_writer :status, statuses #std::STATUS_TRANSFORM.keys

      populating_hash_settable_accessor :price, Price
      populating_hash_settable_accessor :yacht, Yacht

      def central?
	@type == "central"
      end

      def active?
	@status == "active"
      end

      def co_op? 
	@co_op
      end
    end
  end
end

