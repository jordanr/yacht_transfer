require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Tank
      include Model
      attr_accessor :material, :capacity
    end
  end
end
