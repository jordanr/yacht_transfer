require 'yacht_transfer/model'
require 'yacht_transfer/models/measurement'
require 'yacht_transfer/models/yacht'

module YachtTransfer
  module Models
    class Listing
      include Model

      YW_TYPE_TRANSFORM = { :central=>"1", :open=>"2" }
      YW_STATUS_TRANSFORM = { :active=>"x", :inactive=>"x", :in_progress=>"x" }

      FIELDS = [:broker, :type, :status, :co_op]
      populating_attr_reader *FIELDS
      option_checking_attr_writer :type, YW_TYPE_TRANSFORM.keys
      option_checking_attr_writer :status, YW_STATUS_TRANSFORM.keys

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

      def to_yw
	ans = YW_DEFAULTS
	ans.merge!({ :price=>price.value, :currency=>price.units})
	ans.merge!(yacht.to_yw)
	ans
      end

      private 
	YW_DEFAULTS = { :central=>"1", :name_access=>"Public", :specs_access=>"Public",
			:hin_unavailable=>"on", :co_op=>"1"}
    end
  end
end

