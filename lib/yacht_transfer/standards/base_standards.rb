require 'yacht_transfer/models/state'
require 'yacht_transfer/models/country'
module YachtTransfer
  module Standards
    module BaseStandards
      def self.included(model)
        model.extend(ClassMethods)
      end
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
      def yacht_type_transform(key, site); YACHT_TYPE_TRANSFORM[key.to_sym][site.to_sym]; end

      WEIGHT_UNITS_TRANSFORM = {:kilograms =>{}, 
				:pounds => {},
				:tons => {}
				}
      def weight_units_transform(key, site); WEIGHT_UNITS_TRANSFORM[key.to_sym][site.to_sym]; end

      VOLUME_UNITS_TRANSFORM = { :gallons => {}, 
			:liters => {}
			}
      def volume_units_transform(key, site); VOLUME_UNITS_TRANSFORM[key.to_sym][site.to_sym]; end

      SPEED_UNITS_TRANSFORM = {:knots => {},
			:mph => {}
                   	}
      def speed_units_transform(key, site); SPEED_UNITS_TRANSFORM[key.to_sym][site.to_sym]; end

      NEW_TRANSFORM = {true=>{:yw=>"New", :yc=>0},
                       false=>{:yw=>"Used", :yc=>1}
                        }
      def new_transform(key, site); NEW_TRANSFORM[key.to_sym][site.to_sym]; end

      PRICE_UNITS_TRANSFORM = {
				:dollars=>{:yw=>"USD", :yc=>"US Dollar"},
                         	:euros=>{:yw=>"EUR", :yc=>"Euro"}
			}
      def price_units_transform(key, site); PRICE_UNITS_TRANSFORM[key.to_sym][site.to_sym]; end

      DISTANCE_UNITS_TRANSFORM = {
	 			:meters=>{:yw=>"Meters"},
	                         :feet=>{:yw=>"Feet"}
         	               }
      def distance_units_transform(key, site); DISTANCE_UNITS_TRANSFORM[key.to_sym][site.to_sym]; end

      MATERIAL_TRANSFORM = {    :fiberglass=>{:yw=>"FG",:yc=>1},
                                :composite=>{:yw=>"CP", :yc=>5},
                                :wood=>{:yw=>"W", :yc=>3},
                                :steel=>{:yw=>"ST", :yc=>2},
                                :cement=>{:yw=>"FC", :yc=>9},
                                :other=>{:yw=>"O", :yc=>7}
			}
      def material_transform(key, site); MATERIAL_TRANSFORM[key.to_sym][site.to_sym]; end

      FUEL_TRANSFORM = {:diesel=>{:yw=>"Diesel", :yc=>"Diesel"},
                        :gas=>{:yw=>"Gas", :yc=>"Gas"},
                        :other=>{:yw=>"Other", :yc=>"Other"}
                        }
      def fuel_transform(key, site); FUEL_TRANSFORM[key.to_sym][site.to_sym]; end

      LISTING_TYPE_TRANSFORM =  {:central=>{:yw=>"1", :yc=>"1"},
                         :open=>{:yw=>"2", :yc=>"3"}
                        }
      def listing_type_transform(key, site); LISTING_TYPE_TRANSFORM[key.to_sym][site.to_sym]; end

      CO_OP_TRANSFORM = { true=>{:yw=>"1", :yc=>"1"},
                          false=>{:yw=>"2", :yc=>"0"}
                        }
      def co_op_transform(key, site); CO_OP_TRANSFORM[key.to_sym][site.to_sym]; end

      STATUS_TRANSFORM ={:active=>{:yw=>nil, :yc=>"1"},
                         :inactive=>{:yw=>nil, :yc=>"7"},
                         :in_progress=>{:yw=>nil, :yc=> "6"}
#			 :sold=>{:yc=>"5"},
#			 :sale_pending=>{ :yc=>"2"}
                        }
      def status_transform(key, site); STATUS_TRANSFORM[key.to_sym][site.to_sym]; end


      COUNTRY_TRANSFORM = {:"United States of America"=>{:yw=>"United States", :yc=>"48"}
			  }	
      def country_transform(key, site); COUNTRY_TRANSFORM[key.to_sym][site.to_sym]; end

      STATES = YachtTransfer::Models::State.names.sort { |a,b| a.to_s <=> b.to_s }
      COUNTRIES = YachtTransfer::Models::Country.names.sort { |a,b| a.to_s <=> b.to_s }
      STATUSES = STATUS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      CURRENCIES = PRICE_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      YACHT_TYPES = YACHT_TYPE_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      LISTING_TYPES = LISTING_TYPE_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      HULL_MATERIALS = MATERIAL_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      LENGTH_UNITS = DISTANCE_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      WEIGHT_UNITS = WEIGHT_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      VOLUME_UNITS = VOLUME_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      SPEED_UNITS = SPEED_UNITS_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
      FUELS = FUEL_TRANSFORM.keys.sort { |a,b| a.to_s <=> b.to_s }
 
      module ClassMethods
      def states; STATES; end
      def countries; COUNTRIES; end
      def statuses; STATUSES; end
      def currencies; CURRENCIES; end
      def yacht_types; YACHT_TYPES; end
      def listing_types; LISTING_TYPES; end
      def hull_materials; HULL_MATERIALS; end
      def length_units; LENGTH_UNITS; end
      def weight_units; WEIGHT_UNITS; end
      def volume_units; VOLUME_UNITS; end
      def speed_units; SPEED_UNITS; end
      def fuels; FUELS; end
      end
    end
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

