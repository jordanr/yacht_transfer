require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Tank
      include Model
      attr_accessor :material
      attr_reader :capacity
      type_checking_attr_writer :capacity, Numeric
    end
  end
end
