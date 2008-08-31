require 'yacht_transfer/model'
require 'yacht_transfer/standards'
module YachtTransfer
  module Models
    class Measurement
      include Model, Std
      attr_reader :value
      type_checking_attr_writer :value, Numeric
      attr_reader :units
      # subclass defines attr_writer for units

      def to_s
	"#{value} #{units}"
      end
    end

    class Price < Measurement
      option_checking_attr_writer :units, std::PRICE_UNITS_TRANSFORM.keys
    end

    class Distance < Measurement
      option_checking_attr_writer :units, std::DISTANCE_UNITS_TRANSFORM.keys
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


