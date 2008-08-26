require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Accommodation
      include Model
      attr_accessor :title
      attr_accessor :content
    end
  end
end       
