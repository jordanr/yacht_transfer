require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Hull
      include Model
      MATERIAL_TRANSFORM = { 	:fiberglass=>{:yw=>"FG"},
				:composite=>{:yw=>"CP"},
				:wood=>{:yw=>"W"}, 
				:steel=>{:yw=>"ST"}, 
				:cement=>{:yw=>"FC"},
				:other=>{:yw=>"O"}
			   }
      attr_accessor :configuration, :color, :designer
      attr_reader :material
      option_checking_attr_writer :material, MATERIAL_TRANSFORM.keys

      def to_yw
	yw
      end
      def yw
	{ "designer"=>designer, 
	  "hull_material"=>MATERIAL_TRANSFORM[material.to_sym][:yw]
	}
      end
    end
  end
end
