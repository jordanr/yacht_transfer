require 'yacht_transfer/model'
require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    class Engine
      include Model, Standardize
      YW_FUEL_TRANSFORM = {:diesel=>"Diesel", :gas=>"Gas", :other=>"Other"}

      attr_accessor :manufacturer, :model
      attr_reader :horsepower, :year, :hours, :fuel
      type_checking_attr_writer *[:horsepower, :hours].push(Numeric)
      option_checking_attr_writer :year, 1000..9999
      option_checking_attr_writer :fuel, YW_FUEL_TRANSFORM.keys

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
