require 'yacht_transfer/model'
require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Models
    class Measurement
      include Model, YachtTransfer::Standards::BaseStandards
      attr_reader :value
      type_checking_attr_writer :value, Numeric
      attr_reader :units
      # subclass defines attr_writer for units

      def to_s
	"#{value} #{units}"
      end
    end

    class Price < Measurement
      option_checking_attr_writer :units, currencies #std::PRICE_UNITS_TRANSFORM.keys
    end

    class Distance < Measurement
      option_checking_attr_writer :units, length_units #std::DISTANCE_UNITS_TRANSFORM.keys
    end

    class Weight < Measurement
      option_checking_attr_writer :units, weight_units
    end

    class Speed < Measurement
      option_checking_attr_writer :units, speed_units
    end

    class Volume < Measurement
      option_checking_attr_writer :units, volume_units
    end
  end
end


