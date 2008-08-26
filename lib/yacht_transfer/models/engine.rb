require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    class Engine
      include Standardize
      attr_accessor :manufacturer, :model, :fuel, :horsepower, :year, :hours

      def to_yw
	standardize(STD2YW)
      end

      private
	STD2YW = {:fuel=>"fuel",
		  :manufacturer=>"engines",
		  :horsepower=>"engines_hp",
		  :model=>"engine_model",
		  :hours=>"engine_hours"
		 }
    end
  end
end
