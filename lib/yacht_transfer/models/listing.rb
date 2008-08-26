require 'yacht_transfer/model'
require 'yacht_transfer/models/measurement'
require 'yacht_transfer/models/yacht'

module YachtTransfer
  module Models
    class Listing
      include Model

      VALID_TYPES = %w{ open central }
      VALID_STATUSES= %w{ active inactive }  

      FIELDS = [:broker, :type, :status, :co_op]
      populating_attr_accessor *FIELDS
      populating_hash_settable_accessor :price, Measurement
      populating_hash_settable_accessor :yacht, Yacht

      def central?
	@type == "central"
      end

      def active?
	@status == "active"
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

