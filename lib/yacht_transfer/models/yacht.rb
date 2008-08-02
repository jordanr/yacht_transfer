require 'yacht_transfer/model'
require 'yacht_transfer/models/accommodation'
require 'yacht_transfer/models/engine'
require 'yacht_transfer/models/location'
require 'yacht_transfer/models/measurement'
require 'yacht_transfer/models/picture'
require 'yacht_transfer/models/refit'
require 'yacht_transfer/models/tank'

module YachtTransfer
  module Models
    class Yacht
      include Model
  
      FIELDS = [:name, :manufacturer, :model, :category, :rig, :cockpit, :flag, :number_of_staterooms, :number_of_heads, :new, :power]
      populating_attr_accessor *FIELDS
      DIMENSIONS = [:length, :lwl, :lod, :beam, :min_draft, :max_draft, :bridge_clearance]
      WEIGHTS= [:displacement, :ballast]
      RATES =  [:cruise_speed, :max_speed]     
      MEASUREMENTS = DIMENSIONS + WEIGHTS + RATES
      populating_hash_settable_accessor *MEASUREMENTS.push(Measurement)
      populating_hash_settable_accessor :hull, Hull

      populating_hash_settable_list_accessor :accommodations, Accommodation
      populating_hash_settable_list_accessor :engines, Engine
      populating_hash_settable_list_accessor :location, Location
      populating_hash_settable_list_accessor :pictures, Picture
      populating_hash_settable_list_accessor :refits, Refit
      populating_hash_settable_list_accessor :fuel_tank, Tank
      populating_hash_settable_list_accessor :water_tank, Tank
      populating_hash_settable_list_accessor :holding_tank, Tank


      def used
	!@new
      end
      def sail
	!@power
      end
    end
  end
end
