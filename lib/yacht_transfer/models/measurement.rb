require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Measurement
      include Model
      attr_reader :value
      type_checking_attr_writer :value, Numeric
      attr_reader :units
      # subclass defines attr_writer for units

      def to_s
	"#{value} #{units}"
      end
    end

    class Price < Measurement
      UNITS_TRANSFORM = {:dollars=>{:yw=>"USD"},
			 :euros=>{:yw=>"EUR"} 
			}
      option_checking_attr_writer :units, UNITS_TRANSFORM.keys

      def yw
	{ 
	  "currency"=>UNITS_TRANSFORM[units.to_sym][:yw],
	  "price"=>value
        }
      end      
      def to_yw; yw ; end
    end

    class Distance < Measurement
      UNITS_TRANSFORM = {:meters=>{:yw=>"Meters"},
			 :feet=>{:yw=>"Feet"}
			}
      option_checking_attr_writer :units, UNITS_TRANSFORM.keys

    end

    class Weight < Measurement
      option_checking_attr_writer :units, [:pounds, :tons, :kilograms]
    end

    class Speed < Measurement
      option_checking_attr_writer :units, [:knots, :mph]
    end

    class Volume < Measurement
      option_checking_attr_writer :units, [:gallons, :liters]
    end
  end
end


