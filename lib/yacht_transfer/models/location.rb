require 'yacht_transfer/model'
require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    ##
    # Representation of Location used in all places where a Location is specified.
    class Location
      include Model,Standardize
      attr_accessor :city, :country, :state, :region
      attr_reader :zip
      option_checking_attr_writer *[:zip].push(10000..99999)

      def to_yw
        standardize(STD2YW)
      end

      private
        STD2YW = {:city=>"boat_city", :country=>"boat_country"}
    end
  end
end

