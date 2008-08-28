require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Tank
      include Model
      attr_accessor :material
      populating_hash_settable_accessor :capacity, Volume
    end
  end
end
