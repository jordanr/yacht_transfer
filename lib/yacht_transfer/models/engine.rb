require 'yacht_transfer/model'
require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    class Engine
      include Model, Standardize
      attr_accessor :manufacturer, :model, :fuel, :horsepower, :year, :hours
      attr_reader :horsepower, :year, :hours
      type_checking_attr_writer *[:horsepower, :hours].push(Numeric)
      option_checking_attr_writer *[:year].push(1000..9999)

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
