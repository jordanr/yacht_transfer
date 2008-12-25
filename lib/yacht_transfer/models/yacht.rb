require 'yacht_transfer/model' 
require 'yacht_transfer/models/accommodation' 
require 'yacht_transfer/models/engine'
require 'yacht_transfer/models/location' 
require 'yacht_transfer/models/measurement' 
require 'yacht_transfer/models/picture' 
require 'yacht_transfer/models/refit' 
require 'yacht_transfer/models/tank'
require 'yacht_transfer/standards'
module YachtTransfer
  module Models
    class Yacht
      include Model, Std

      FIELDS = [:name, :manufacturer, :model, :category, :rig, :cockpit, :flag, :new, :description]
      NUMERIC_FIELDS = [:number_of_staterooms, :number_of_heads]
      
      populating_attr_accessor *FIELDS
      populating_attr_reader *NUMERIC_FIELDS
      type_checking_attr_writer *NUMERIC_FIELDS.push(Numeric)
      populating_attr_reader :year, :type
      option_checking_attr_writer :year, 1000..9999
      option_checking_attr_writer :type, std::YACHT_TYPE_TRANSFORM.keys
      DIMENSIONS = [:length, :lwl, :loa, :beam, :min_draft, :max_draft, :bridge_clearance]
      WEIGHTS= [:displacement, :ballast]
      RATES =  [:cruise_speed, :max_speed]     
#      MEASUREMENTS = DIMENSIONS + WEIGHTS + RATES
      populating_hash_settable_accessor *DIMENSIONS.push(Distance)
      populating_hash_settable_accessor *WEIGHTS.push(Weight)
      populating_hash_settable_accessor *RATES.push(Speed)

      populating_hash_settable_accessor :hull, Hull
      populating_hash_settable_accessor :fuel_tank, Tank
      populating_hash_settable_accessor :water_tank, Tank
      populating_hash_settable_accessor :holding_tank, Tank
      populating_hash_settable_accessor :location, Location

      populating_hash_settable_list_accessor :accommodations, Accommodation
      populating_hash_settable_list_accessor :engines, Engine
      populating_hash_settable_list_accessor :pictures, Picture
      populating_hash_settable_list_accessor :refits, Refit

      def used
	!@new
      end
      alias :used? :used

      def sail
	!@power
      end
      alias :sail? :sail
    end
  end
end
