require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Accommodation
      include Model
      attr_accessor :title
      attr_accessor :content
      attr_accessor :left
      attr_accessor :right
    end
  end
end       
