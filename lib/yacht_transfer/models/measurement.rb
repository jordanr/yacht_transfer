require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Measurement
      include Model
      attr_accessor :value
      attr_accessor :units
    end
  end
end
