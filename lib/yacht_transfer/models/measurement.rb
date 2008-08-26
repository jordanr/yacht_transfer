require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Measurement
      include Model
      attr_reader :value
      type_checking_attr_writer :value, Numeric
      attr_accessor :units
    end
  end
end
