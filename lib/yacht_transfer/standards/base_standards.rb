module YachtTransfer
  module Standards
    module BaseStandards
      def self.included(model)
#        model.extend(ClassMethods)
      end

      ##########################
      # Main Transform
      ########################

      KEY_TRANSFORM = {		:username=> {:yw=>:url, :yc=>""},
				:id => {:yw=> :boat_id, :yc=>:vessels_id},
				:price => {:yw=>:price, :yc=> :ask_price},
				:yacht_name => { :yw=>:name , :yc=>:name},
				:yacht_location => {:yw=>:boat_city, :yc=>:city},
				:yacht_specification_length => {:yw=> :length, :yc=> :length},
				:yacht_specification_manufacturer => {:yw=> :maker, :yc=> :vessel_manufacturer_name},
				:yacht_specification_model=> {:yw=>:model, :yc=>:model},
				:yacht_specification_year=> {:yw=>:year, :yc=>:built_in_year},
				:yacht_specification_material=> {:yw=>:hull_material, :yc=>:hull_materials_id},
				:yacht_specification_fuel=> {:yw=>:fuel, :yc=> :fuel_types_id},
				:yacht_specification_number_of_engines => {:yw=>:engine_num, :yc=>:number_of_engines },
				:yacht_specification_designer => { :yw=> :designer, :yc=>:hull_designer}
			}
      def key_transform(key, site); KEY_TRANSFORM[key.to_sym][site.to_sym]; end


      ######################
      # Value Transforms
      ######################

      MATERIAL_TRANSFORM = {    :fiberglass=>{:yw=>"FG",:yc=>"1"},
                                :composite=>{:yw=>"CP", :yc=>"5"},
                                :wood=>{:yw=>"W", :yc=>"3"},
                                :steel=>{:yw=>"ST", :yc=>"2"},
                                :cement=>{:yw=>"FC", :yc=>"9"},
                                :other=>{:yw=>"O", :yc=>"7"}
                        }
      MATERIAL_TRANSFORM.default = {:yw=>"O", :yc=>"7"}
      def material_transform(key, site)
        key = :other if key == ""
        MATERIAL_TRANSFORM[key.to_sym][site.to_sym]
      end        


      FUEL_TRANSFORM = {:diesel=>{:yw=>"Diesel", :yc=>"Diesel"},
                        :gas=>{:yw=>"Gas", :yc=>"Gas"},
                        :other=>{:yw=>"Other", :yc=>"Other"}
                        }
      FUEL_TRANSFORM.default = {:yw=>"Other", :yc=>"Other"}
      def fuel_transform(key, site)
        key = :other if key == ""
        FUEL_TRANSFORM[key.to_sym][site.to_sym]
      end
    end
  end
end
