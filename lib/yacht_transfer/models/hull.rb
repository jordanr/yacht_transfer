require 'yacht_transfer/model'
require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    class Hull
      include Model,Standardize
      YW_MATERIAL_TRANSFORM = { :fiberglass=>"FG", :composite=>"CP",
				:wood=>"W", :steel=>"ST", :cement=>"FC",
				:other=>"O" }
      attr_accessor :configuration, :color, :designer
      attr_reader :material
      option_checking_attr_writer :material, YW_MATERIAL_TRANSFORM.keys

      def to_yw
	standardize(STD2YW)
      end

      private
	STD2YW = {:designer=>"designer", :material=>"hull_material"}
    end
  end
end
