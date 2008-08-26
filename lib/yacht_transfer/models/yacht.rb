require 'yacht_transfer/model' 
require 'yacht_transfer/models/accommodation' 
require 'yacht_transfer/models/engine'
require 'yacht_transfer/models/location' 
require 'yacht_transfer/models/measurement' 
require 'yacht_transfer/models/picture' 
require 'yacht_transfer/models/refit' 
require 'yacht_transfer/models/tank'
require 'yacht_transfer/standardize'

module YachtTransfer
  module Models
    class Yacht
      include Model, Standardize
  
      FIELDS = [:name, :manufacturer, :model, :category, :rig, :cockpit, :flag, :number_of_staterooms, :number_of_heads, :new, :power, :year]
      populating_attr_accessor *FIELDS
      DIMENSIONS = [:length, :lwl, :loa, :beam, :min_draft, :max_draft, :bridge_clearance]
      WEIGHTS= [:displacement, :ballast]
      RATES =  [:cruise_speed, :max_speed]     
      MEASUREMENTS = DIMENSIONS + WEIGHTS + RATES
      populating_hash_settable_accessor *MEASUREMENTS.push(Measurement)

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
      def sail
	!@power
      end

      def to_yw
	ans = standardize(STD2YW)

	STD2YW_MEASUREMENTS.each { |k,v|
	  ans.merge!({v=>send(k).value})
	}
        ans.merge!({:units=>length.units})
	ans.merge!(hull.to_yw)
	ans.merge!(location.to_yw)
	ans.merge!({:fuel_tank=>fuel_tank.capacity})
	ans.merge!({:water_tank=>water_tank.capacity})
	ans.merge!({:holding_tank=>holding_tank.capacity})

	titles = {}
	contents = {}
#	accommodations.each_with_index { |a, n|
#	  titles.merge!({n.to_sym=>a.title})
#	  contents.merge!({n.to_sym=>a.content})
 # 	}
#	ans.merge!({:title=>titles})
#	ans.merge!({:content=>contents})

#	ans.merge!(engines.first.to_yw)
#	ans.merge!(:engine_num=>engines.length)
#	ans.merge!(refits.first.to_yw)
	ans
      end

      private
	STD2YW={:name=>"name",
		:manufacturer=>"maker",
		:model =>"model",
		:year=>"year"
	       }
        STD2YW_MEASUREMENTS={
		:length=>"length",
		:lwl=>"lwl",
		:loa=>"loa",
		:beam=>"beam",
		:min_draft=>"draft",
		:bridge_clearance=>"clearance",
		:displacement=>"displacement",
		:ballast=>"ballast",
		:cruise_speed=>"cruising_speed",
		:max_speed=>"max_speed" }
    end
  end
end
