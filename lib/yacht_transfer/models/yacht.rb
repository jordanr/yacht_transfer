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

      TYPE_TRANSFORM ={"power"=>{:yw=>["(Power) Motoryacht with cockpit", 
					"(Power) Motoryacht without cockpit", "(Power) Motoryacht with flybridge", 
					"(Power) Sedan/Convertible", "(Power) Express", "(Power) High Performance", 
					"(Power) Trawler", "(Power) Pilothouse", "(Power) Open Fisherman", 
					"(Power) Freshwater Fishing", "(Power) Saltwater Inshore Fishing", 
					"(Power) Saltwater Offshore Fishing", "(Power) Sport Fisherman", 
					"(Power) Center Console", "(Power) Downeast", "(Power) Houseboat", 
					"(Power) Antique and Classic", "(Power) Small Cruiser", "(Power) Runabout", 
					"(Power) Cuddy Cabin", "(Power) Bowrider", "(Power) Catamaran", 
					"(Power) Narrowboat", "(Power) Pontoon", "(Power) Tender", "(Power) Superyacht"]
				 },
			 "sail"=>{:yw=>["(Sail) Cruiser", "(Sail) Racer", "(Sail) Cruiser/Racer", 
					"(Sail) Center Cockpit", "(Sail) Multi-hull", "(Sail) Motorsailer/Pilothouse", 
					"(Sail) Deck Saloon", "(Sail) Daysailer/Weekender"]
				 },
			 "commercial"=>{:yw=>["(Commercial) Barge", "(Commercial) Bristol Bay", "(Commercial) Bowpicker", 
					"(Commercial) Cargo", "(Commercial) Charter", "(Commercial) Combination", 
					"(Commercial) Crabber", "(Commercial) Crew", "(Commercial) Dive", 
					"(Commercial) Dragger", "(Commercial) Longliner", "(Commercial) Passenger", 
					"(Commercial) Processor", "(Commercial) Seiner", "(Commercial) Skiff", 
					"(Commercial) Sternpicker", "(Commercial) Tender", "(Commercial) Tuna", 
					"(Commercial) Troller", "(Commercial) Tug", "(Commercial) Utility/Supply"]
				 }
		            }

      NEW_TRANSFORM = {true=>{:yw=>"New"},
		       false=>{:yw=>"Used"}
			}
  
      FIELDS = [:name, :manufacturer, :model, :category, :rig, :cockpit, :flag, :new]
      NUMERIC_FIELDS = [:number_of_staterooms, :number_of_heads]
      
      populating_attr_accessor *FIELDS
      populating_attr_reader *NUMERIC_FIELDS
      type_checking_attr_writer *NUMERIC_FIELDS.push(Numeric)
      populating_attr_reader :year, :type
      option_checking_attr_writer :year, 1000..9999
      option_checking_attr_writer :type, TYPE_TRANSFORM.keys
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

      def yw 
	{
          "name"=>name,
          "maker"=>manufacturer,
          "model"=>model,
          "year"=>year,
          "length"=>length.value,
	  "units"=>Distance::UNITS_TRANSFORM[length.units.to_sym][:yw],
          "lwl"=>lwl.to_s,
          "loa"=>loa.to_s,
          "beam"=>beam.to_s,
          "draft"=>min_draft.to_s,      
          "clearance"=>bridge_clearance.to_s,
          "displacement"=>displacement.to_s,
          "ballast"=>ballast.to_s,
          "cruising_speed"=>cruise_speed.to_s,        
          "max_speed"=>max_speed.to_s,
	  "fuel_tank"=>fuel_tank.capacity.to_s,
          "water_tank"=>water_tank.capacity.to_s,
	  "holding_tank"=>holding_tank.capacity.to_s,
	  "boat_new"=>NEW_TRANSFORM[new ? true : false][:yw],
	  "engine_num"=>(1..3).include?(engines.length) ? engines.length : 3
        }
      end

      def used
	!@new
      end

      def sail
	!@power
      end

      def to_yw
	ans = yw

	ans.merge!(hull.to_yw)
	ans.merge!(location.to_yw)
	ans.merge!(engines.first.to_yw)
#	ans.merge!(refits.first.to_yw)

	titles = {}
	contents = {}
#	accommodations.each_with_index { |a, n|
#	  titles.merge!({n.to_sym=>a.title})
#	  contents.merge!({n.to_sym=>a.content})
 # 	}
#	ans.merge!({:title=>titles})
#	ans.merge!({:content=>contents})

	ans
      end
    end
  end
end
