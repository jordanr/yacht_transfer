require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Engine
      include Model
      FUEL_TRANSFORM = {:diesel=>{:yw=>"Diesel"}, 
			:gas=>{:yw=>"Gas"}, 
			:other=>{:yw=>"Other"}
			}

      attr_accessor :manufacturer, :model
      attr_reader :horsepower, :year, :hours, :fuel
      type_checking_attr_writer *[:horsepower, :hours].push(Numeric)
      option_checking_attr_writer :year, 1000..9999
      option_checking_attr_writer :fuel, FUEL_TRANSFORM.keys

      def to_yw
	yw
      end

      def yw
	{
	  "fuel"=>FUEL_TRANSFORM[fuel.to_sym][:yw],
  	  "engines"=>manufacturer,
  	  "engines_hp"=>horsepower,
	  "engine_model"=>model,
	  "engine_hours"=>hours
	}
      end
    end
  end
end
