require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Measurement
      include Model
      attr_reader :value
      type_checking_attr_writer :value, Numeric
      attr_reader :units
      # subclass defines attr_writer for units
    end

    class Price < Measurement
      STD2YW = {:dollars=>"USD",:euros=>"EUR"}
      option_checking_attr_writer :units, STD2YW.keys

    end
    class Distance < Measurement
      option_checking_attr_writer :units, [:meters, :feet]
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


