require 'yacht_transfer/model'
module YachtTransfer
  module Models
    class Refit
      include Model
      attr_accessor :type
      attr_reader :year
      option_checking_attr_writer :year, 1000..9999
    end
  end
end
