require 'yacht_transfer/models/state'
require 'yacht_transfer/models/country'
module YachtTransfer
  module Standards
    module YachtWorldStandards
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

      YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME = 5

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

#      def yacht; listing.yacht; end
#      def engine; yacht.engines.first; end

      def yw_params
	{
	:url=>username,
	:lang=>"en",
	:revised_date=>Time.now.strftime("%Y%m%d"),
	:pass_office_id=>"",
	:pass_broker_id=>""
	}
      end	

      def yw_start_params(listing)
	yacht = listing.yacht
	params = yw_params
	params.merge!({
	:action=>"Add",
        :year=>yacht.year,
	:length=>yacht.length.value,
        :units=>DISTANCE_UNITS_TRANSFORM[yacht.length.units.to_sym][:yw],
	:verify=>"1",
	:new_maker_flag=>"0",
	:maker=>yacht.manufacturer
	})
      end

      def yw_basic_params(listing, id)
	yacht = listing.yacht
	engine = yacht.engines.first
	params = yw_params
	params.merge!({
	:boat_id=>id ? id : "New",
	:old_price=>"",
	:old_local_price=>"",
	:old_currency=>"",
	:first_price_change=>"1",
	:action=>id ? "Edit" : "Add",
	:boats_clobs_id=>id ? nil : "New",

	:maker=>yacht.manufacturer,
	:model=>yacht.model,
        :central=>LISTING_TYPE_TRANSFORM[listing.type.to_sym][:yw],
        :co_op =>CO_OP_TRANSFORM[listing.co_op? ? true : false][:yw],
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
	:boat_state=>YachtTransfer::Models::State.abbreviation(yacht.location.state),
        :boat_country=>COUNTRY_TRANSFORM.keys.include?(yacht.location.country.to_sym) ? COUNTRY_TRANSFORM[yacht.location.country.to_sym][:yw] : yacht.location.country,
	:description=>yacht.description,
	:contact_info=>listing.contact_info,
#	:photo_sort_order_1=>"1", # disabled
	:office_id=>"", # get ids?
	:broker_id=>"", # get ids?
	:full_specs=>"Full Specs" # submit
	})
      end

      def yw_add_accommodation_params(id)
	params = yw_params
	params.merge!({
          :boat_id=>id ? id : raise(StandardError, "need boat id"),
    	  :action=>"Edit",
	  :ops=>"",
	  :add_desc=>"Add a Description"
	})
      end

      def yw_details_params(listing, id, clob_ids=nil)
	yacht = listing.yacht
	engine = yacht.engines.first
	params = yw_params
	params.merge!({
          :boat_id=>id ? id : raise(StandardError, "need boat id"),
    	  :action=>"Edit",
	  :ops=>"",
#	  :save_default_access=>"1", # never
	  :name_access=>"PublicUsers",
	  :name=>yacht.name,
	  :specs_access=>"PublicUsers",
          :builder=>yacht.manufacturer,
	  :designer=>yacht.hull.designer,
	  :loa=>yacht.loa.to_s,
	  :lwl=>yacht.lwl.to_s,
	  :beam=>yacht.beam.to_s,
          :draft=>yacht.min_draft.to_s,
          :clearance=>yacht.bridge_clearance.to_s,
          :displacement=>yacht.displacement.to_s,
          :ballast=>yacht.ballast.to_s,
          :engines=>engine.manufacturer,
          :engine_hp=>engine.horsepower.to_s,
          :engine_model=>engine.model,
          :cruising_speed=>yacht.cruise_speed.to_s,
          :engine_hours=>engine.hours,
          :max_speed=>yacht.max_speed.to_s,
          :fuel_tank=>yacht.fuel_tank.capacity.to_s,
          :water_tank=>yacht.water_tank.capacity.to_s,
          :holding_tank=>yacht.holding_tank.capacity.to_s,
#	  :specs_default=>"1", # never
	  :ad=>"Display Ad" # submit
        })
	a = yacht.accommodations
	clob_ids.each_with_index do |i, n|
	  x = n+1
	  params.merge!({
		"clob_id_#{x}"=> i, # get ids?
		"desc_order_#{x}"=>x, # ?
		"clob_title_#{x}"=>a[n]? a[n].title : "",
		"description_access_#{x}"=>"PublicUsers", # ?
		"clob_paragraph_#{x}"=>a[n] ? a[n].content : "",
		"clob_left_#{x}"=>a[n] ? a[n].left : "",
		"clob_right_#{x}"=>a[n] ? a[n].right : ""
	  })
	  params.merge!({"delete_#{x}"=> "1"}) if !a[n]
	end
	params
      end

      def yw_photo_params(listing, id, s)
	yacht = listing.yacht
        raise(StandardError, "need boat id") if !id
	params = {:submit=>"Save Photo"}
	p = yacht.pictures
	t = s + YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME
	(s...t).each do |n|
  	  params.merge!({"fileName_#{n}"=> p[n-1].src}) if (p[n-1])
	end
	params
      end

      # Pre : Pictures are uploaded
      def yw_basic_with_photo_params(listing, id)
	yacht = listing.yacht	
        raise(StandardError, "need boat id") if !id
	params = yw_basic_params(listing, id)
	yacht.pictures.except(0).each_with_index { |p, n|
	  real_index = n+2
  	  params.merge!({
			"photo_description_#{real_index}"=> p.label,
			"photo_sort_order_#{real_index}"=>real_index
			})
	}
        params
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

