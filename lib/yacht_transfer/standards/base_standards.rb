module YachtTransfer
  module Standards
    module BaseStandards
      def self.included(model)
#        model.extend(ClassMethods)
      end

      KEY_TRANSFORM = {		:username=> {:yw=>:url},
				:id => {:yw=> :boat_id},
				:price => {:yw=>:price},
				:yacht_name => { :yw=>:name },
				:yacht_location => {:yw=>:boat_city},
				:yacht_specification_length => {:yw=> :length},
				:yacht_specification_manufacturer => {:yw=> :maker},
				:yacht_specification_model=> {:yw=>:model},
				:yacht_specification_year=> {:yw=>:year}
			}
      def key_transform(key, site); KEY_TRANSFORM[key.to_sym][site.to_sym]; end
    end
  end
end
