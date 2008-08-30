require 'yacht_transfer/model'
require 'yacht_transfer/models/measurement'
require 'yacht_transfer/models/yacht'

module YachtTransfer
  module Models
    class Listing
      include Model

      TYPE_TRANSFORM =  {:central=>{:yw=>"1"}, 
			 :open=>{:yw=>"2"} 
			}
      CO_OP_TRANSFORM = { true=>{:yw=>"1"},
			  false=>{:yw=>"2"}
			}
      STATUS_TRANSFORM ={:active=>{:yw=>nil},
			 :inactive=>{:yw=>nil}, 
			 :in_progress=>{:yw=>nil}
			}

      FIELDS = [:broker, :type, :status, :co_op]
      populating_attr_reader *FIELDS
      attr_writer :broker, :co_op
      option_checking_attr_writer :type, TYPE_TRANSFORM.keys
      option_checking_attr_writer :status, STATUS_TRANSFORM.keys

      populating_hash_settable_accessor :price, Price
      populating_hash_settable_accessor :yacht, Yacht

      def yw
        { 
	  "central"=>TYPE_TRANSFORM[type.to_sym][:yw],
	  "co_op" =>CO_OP_TRANSFORM[co_op? ? true : false][:yw]
	}
      end

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
	ans.merge!(yw)
 	ans.merge!(price.to_yw)
	ans.merge!(yacht.to_yw)
	ans
      end

      private 
	YW_DEFAULTS = { :name_access=>"Public", :specs_access=>"Public",
			:hin_unavail=>"on", :tax=>""}
    end
  end
end

