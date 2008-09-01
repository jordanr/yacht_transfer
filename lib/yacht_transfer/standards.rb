module YachtTransfer
  module Standards
      YACHT_TYPE_TRANSFORM = {:power=>{:yw=>[ "(Power) Motoryacht with cockpit\n", 
					"(Power) Motoryacht without cockpit\n", 
                                        "(Power) Motoryacht with flybridge\n"]
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
                                 },
                        :sail=>{:yw=>[  "(Sail) Cruiser\n", "(Sail) Racer\n", "(Sail) Cruiser/Racer\n"]
#                                       "(Sail) Center Cockpit\n", "(Sail) Multi-hull\n", 
#                                       "(Sail) Motorsailer/Pilothouse\n", 
#                                       "(Sail) Deck Saloon\n", "(Sail) Daysailer/Weekender\n"]
                                 },
                        :commercial=>{:yw=>["(Commercial) Barge\n", "(Commercial) Bristol Bay\n", 
                                        "(Commercial) Bowpicker\n"]
#                                       "(Commercial) Cargo\n", 
#                                       "(Commercial) Charter\n", "(Commercial) Combination\n", 
#                                       "(Commercial) Crabber\n", "(Commercial) Crew\n", "(Commercial) Dive\n", 
#                                       "(Commercial) Dragger\n", "(Commercial) Longliner\n", 
#                                       "(Commercial) Passenger\n", "(Commercial) Processor\n", 
#                                       "(Commercial) Seiner\n", "(Commercial) Skiff\n", 
#                                       "(Commercial) Sternpicker\n", "(Commercial) Tender\n", 
#                                       "(Commercial) Tuna\n", "(Commercial) Troller\n", 
#                                       "(Commercial) Tug\n", "(Commercial) Utility/Supply\n"]
                                 }
                            }

      NEW_TRANSFORM = {true=>{:yw=>"New"},
                       false=>{:yw=>"Used"}
                        }

      PRICE_UNITS_TRANSFORM = {
				:dollars=>{:yw=>"USD"},
                         	:euros=>{:yw=>"EUR"}
			}
      DISTANCE_UNITS_TRANSFORM = {
	 			:meters=>{:yw=>"Meters"},
	                         :feet=>{:yw=>"Feet"}
         	               }
      MATERIAL_TRANSFORM = {    :fiberglass=>{:yw=>"FG"},
                                :composite=>{:yw=>"CP"},
                                :wood=>{:yw=>"W"},
                                :steel=>{:yw=>"ST"},
                                :cement=>{:yw=>"FC"},
                                :other=>{:yw=>"O"}
			}
      FUEL_TRANSFORM = {:diesel=>{:yw=>"Diesel"},
                        :gas=>{:yw=>"Gas"},
                        :other=>{:yw=>"Other"}
                        }

      LISTING_TYPE_TRANSFORM =  {:central=>{:yw=>"1"},
                         :open=>{:yw=>"2"}
                        }
      CO_OP_TRANSFORM = { true=>{:yw=>"1"},
                          false=>{:yw=>"2"}
                        }
      STATUS_TRANSFORM ={:active=>{:yw=>nil},
                         :inactive=>{:yw=>nil},
                         :in_progress=>{:yw=>nil}
                        }
      def yacht
	listing.yacht
      end
      def engine
	yacht.engines.first
      end

      def yw_start_params
	{
	:url=>username,
	:lang=>"en",
	:revised_date=>Time.now.strftime("%Y%m%d"),
	:action=>"Add",
        :year=>yacht.year,
	:length=>yacht.length.value,
        :units=>DISTANCE_UNITS_TRANSFORM[yacht.length.units.to_sym][:yw],
	:verify=>"1",
	:new_maker_flag=>"0",
	:pass_office_id=>"",
	:pass_broker_id=>"",
	:maker=>yacht.manufacturer
	}
      end

      def yw_basic_params
	{
        :central=>LISTING_TYPE_TRANSFORM[listing.type.to_sym][:yw],
        :co_op =>CO_OP_TRANSFORM[listing.co_op? ? true : false][:yw],
	:boat_id=>"New",
	:url=>username,
	:old_price=>"",
	:old_local_price=>"",
	:old_currency=>"",
	:first_price_change=>"1",
	:maker=>yacht.manufacturer,
	:pass_office_id=>"",
	:pass_broker_id=>"",
	:lang=>"en",
	:revised_date=>Time.now.strftime("%Y%m%d"),
	:action=>"Add",
	:boats_clobs_id=>"New",
	:model=>yacht.model,
	:length=>yacht.length.value,
	:year=>yacht.year,
        :price=>listing.price.value,
	:hin=>"",
        :units=>DISTANCE_UNITS_TRANSFORM[yacht.length.units.to_sym][:yw], # converts length to feet
        :currency=>PRICE_UNITS_TRANSFORM[listing.price.units.to_sym][:yw],
        :boat_type=>YACHT_TYPE_TRANSFORM[yacht.type.to_sym][:yw],
        :hin_unavail=>"on",  
        :tax=>"",     
        :fuel=>FUEL_TRANSFORM[engine.fuel.to_sym][:yw],
        :engine_num=>(1..3).include?(yacht.engines.length) ? yacht.engines.length : 3,
	:hull_material=>MATERIAL_TRANSFORM[yacht.hull.material.to_sym][:yw],
        :boat_new=>NEW_TRANSFORM[yacht.new ? true : false][:yw],
        :boat_city=>yacht.location.city,
	:boat_state=>yacht.location.state,
        :boat_country=>"United States", #yacht.location.country,
	:description=>"lala",#yacht.description,
	:contact_info=>"dada",#listing.contact_info,
#	:photo_sort_order_1=>"1", # disabled
	:office_id=>"", # ids
	:broker_id=>"", # ids
	:full_specs=>"Full Specs" # submit
	}
      end

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
          "engine_num"=>(1..3).include?(engines.length) ? engines.length : 3,
          "boat_type"=>TYPE_TRANSFORM[type.to_sym][:yw],
          "currency"=>PRICE_UNITS_TRANSFORM[listing.price.units.to_sym][:yw],
          "price"=>value,
          "boat_city"=>city,
          "boat_country"=>country,
          "designer"=>designer,
          "hull_material"=>MATERIAL_TRANSFORM[material.to_sym][:yw],
          "fuel"=>FUEL_TRANSFORM[fuel.to_sym][:yw],
          "engines"=>manufacturer,
          "engines_hp"=>horsepower,
          "engine_model"=>model,
          "engine_hours"=>hours,
          "name_access"=>"Public", 
	  "specs_access"=>"Public",
          "hin_unavail"=>"on", 
	  "tax"=>"",
          "central"=>TYPE_TRANSFORM[listing.type.to_sym][:yw],
          "co_op" =>CO_OP_TRANSFORM[listing.co_op? ? true : false][:yw]
        }
      end

  end

  module Std
      def self.included(model)
        model.extend(ClassMethods)
      end

      module ClassMethods
        def std
          YachtTransfer::Standards
        end
      end
  end
end
