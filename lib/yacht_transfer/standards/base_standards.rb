module YachtTransfer
  module Standards
    module BaseStandards
      def self.included(model)
#        model.extend(ClassMethods)
      end

      KEY_TRANSFORM = {		:username=> {:yw=>:url, :yc=>""},
				:id => {:yw=> :boat_id, :yc=>:vessels_id},
				:price => {:yw=>:price, :yc=> :ask_price},
				:yacht_name => { :yw=>:name , :yc=>:name},
				:yacht_location => {:yw=>:boat_city, :yc=>:city},
				:yacht_specification_length => {:yw=> :length, :yc=> :length},
				:yacht_specification_manufacturer => {:yw=> :maker, :yc=> :vessel_manufacturer_name},
				:yacht_specification_model=> {:yw=>:model, :yc=>:model},
				:yacht_specification_year=> {:yw=>:year, :yc=>:built_in_year}
			}
      def key_transform(key, site); KEY_TRANSFORM[key.to_sym][site.to_sym]; end
    end
  end
end
