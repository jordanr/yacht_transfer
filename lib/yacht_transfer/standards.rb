require 'yacht_transfer/models/state'
require 'yacht_transfer/models/country'
require 'yacht_transfer/standards/yacht_council_standards'
require 'yacht_transfer/standards/yacht_world_standards'
module YachtTransfer
  module Standards
    include YachtCouncilStandards, YachtWorldStandards
      YACHT_TYPE_TRANSFORM = {:power=>{:yw=>[ "(Power) Motoryacht with cockpit\n", 
					"(Power) Motoryacht without cockpit\n", 
                                        "(Power) Motoryacht with flybridge\n"],
#                                       "(Power) Sedan/Convertible\n", 
#                                       "(Power) Express\n", "(Power) High Performance\n",
#                                       "(Power) Trawler\n", "(Power) Pilothouse\n", "(Power) Open Fisherman\n", 
#                                       "(Power) Freshwater Fishing\n", "(Power) Saltwater Inshore Fishing\n", 
#                                       "(Power) Saltwater Offshore Fishing\n", "(Power) Sport Fisherman\n", 
#                                       "(Power) Center Console\n", "(Power) Downeast\n", "(Power) Houseboat\n", 
#                                       "(Power) Antique and Classic\n", "(Power) Small Cruiser\n", 
#                                       "(Power) Runabout\n", "(Power) Cuddy Cabin\n", 
#                                       "(Power) Bowrider\n", "(Power) Catamaran\n", 
#                                       "(Power) Narrowboat\n", "(Power) Pontoon\n", 
#                                       "(Power) Tender\n", "(Power) Superyacht\n"]
                    		:yc=>2},
                        :sail=>{:yw=>[  "(Sail) Cruiser\n", "(Sail) Racer\n", "(Sail) Cruiser/Racer\n"],
#                                       "(Sail) Center Cockpit\n", "(Sail) Multi-hull\n", 
#                                       "(Sail) Motorsailer/Pilothouse\n", 
#                                       "(Sail) Deck Saloon\n", "(Sail) Daysailer/Weekender\n"]
                               	:yc=>1},
                        :commercial=>{:yw=>["(Commercial) Barge\n", "(Commercial) Bristol Bay\n", 
                                        "(Commercial) Bowpicker\n"],
#                                       "(Commercial) Cargo\n", 
#                                       "(Commercial) Charter\n", "(Commercial) Combination\n", 
#                                       "(Commercial) Crabber\n", "(Commercial) Crew\n", "(Commercial) Dive\n", 
#                                       "(Commercial) Dragger\n", "(Commercial) Longliner\n", 
#                                       "(Commercial) Passenger\n", "(Commercial) Processor\n", 
#                                       "(Commercial) Seiner\n", "(Commercial) Skiff\n", 
#                                       "(Commercial) Sternpicker\n", "(Commercial) Tender\n", 
#                                       "(Commercial) Tuna\n", "(Commercial) Troller\n", 
#                                       "(Commercial) Tug\n", "(Commercial) Utility/Supply\n"]
                                 :yc=> 2}
		}
      WEIGHT_UNITS_TRANSFORM = {:kilograms =>{}, 
				:pounds => {},
				:tons => {}
				}
      VOLUME_UNITS_TRANSFORM = { :gallons => {}, 
			:liters => {}
			}
      SPEED_UNITS_TRANSFORM = {:knots => {},
			:mph => {}
                   	}

      NEW_TRANSFORM = {true=>{:yw=>"New", :yc=>0},
                       false=>{:yw=>"Used", :yc=>1}
                        }

      PRICE_UNITS_TRANSFORM = {
				:dollars=>{:yw=>"USD", :yc=>"US Dollar"},
                         	:euros=>{:yw=>"EUR", :yc=>"Euro"}
			}
      DISTANCE_UNITS_TRANSFORM = {
	 			:meters=>{:yw=>"Meters"},
	                         :feet=>{:yw=>"Feet"}
         	               }
      MATERIAL_TRANSFORM = {    :fiberglass=>{:yw=>"FG",:yc=>1},
                                :composite=>{:yw=>"CP", :yc=>5},
                                :wood=>{:yw=>"W", :yc=>3},
                                :steel=>{:yw=>"ST", :yc=>2},
                                :cement=>{:yw=>"FC", :yc=>9},
                                :other=>{:yw=>"O", :yc=>7}
			}
      FUEL_TRANSFORM = {:diesel=>{:yw=>"Diesel", :yc=>"Diesel"},
                        :gas=>{:yw=>"Gas", :yc=>"Gas"},
                        :other=>{:yw=>"Other", :yc=>"Other"}
                        }

      LISTING_TYPE_TRANSFORM =  {:central=>{:yw=>"1", :yc=>"1"},
                         :open=>{:yw=>"2", :yc=>"3"}
                        }
      CO_OP_TRANSFORM = { true=>{:yw=>"1", :yc=>"1"},
                          false=>{:yw=>"2", :yc=>"0"}
                        }
      STATUS_TRANSFORM ={:active=>{:yw=>nil, :yc=>"1"},
                         :inactive=>{:yw=>nil, :yc=>"7"},
                         :in_progress=>{:yw=>nil, :yc=> "6"}
#			 :sold=>{:yc=>"5"},
#			 :sale_pending=>{ :yc=>"2"}
                        }

      COUNTRY_TRANSFORM = {:"United States of America"=>{:yw=>"United States", :yc=>"48"}
			  }	
      STATES = YachtTransfer::Models::State.names.sort { |a,b| a.to_s <=> b.to_s }
      COUNTRIES = YachtTransfer::Models::Country.names.sort { |a,b| a.to_s <=> b.to_s }
      STATUSES = STATUS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      CURRENCIES = PRICE_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      YACHT_TYPES = YACHT_TYPE_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      HULL_MATERIALS = MATERIAL_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      LENGTH_UNITS = DISTANCE_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      WEIGHT_UNITS = WEIGHT_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      VOLUME_UNITS = VOLUME_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      SPEED_UNITS = SPEED_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      FUELS = FUEL_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
  end

  module Std
      def self.included(model)
        model.extend(ClassMethods)
      end

      def std
        YachtTransfer::Standards
      end

      module ClassMethods
        def std
          YachtTransfer::Standards
        end
      end
  end
end

