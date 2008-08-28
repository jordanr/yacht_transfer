require 'yacht_transfer/model'
require 'yacht_transfer/models/country'
require 'yacht_transfer/models/state'
require 'yacht_transfer/standardize'
module YachtTransfer
  module Models
    ##
    # Representation of Location used in all places where a Location is specified.
    class Location
      include Model,Standardize
      attr_accessor :city, :region
      attr_reader :zip, :state, :country
      option_checking_attr_writer :zip, 10000..99999
      option_checking_attr_writer :state, State.abbreviations
      option_checking_attr_writer :country, Country.names

      def to_yw
        standardize(STD2YW)
      end

      private
        STD2YW = {:city=>"boat_city", :country=>"boat_country"}
    end
  end
end

