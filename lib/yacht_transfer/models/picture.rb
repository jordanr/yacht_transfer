require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Picture
      include Model
      attr_accessor :label, :src
    end
  end
end
