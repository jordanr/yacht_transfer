require 'yacht_transfer/models/state'
require 'yacht_transfer/models/country'
module YachtTransfer
  module YachtCouncilStandards

      YC_LENGTH_THRESHOLD = 80

      def yc_params
	{
	:member_company_id=>"",
	:login_id=>""
	}
      end	

      def yc_basic_params(listing, id)
	yacht = listing.yacht
	engine = yacht.engines.first
	params = yc_params
	params.merge!({
	# hidden
	:vessels_entry_step_frm_auto=>"1",	
	:vessels_id=>id ? id : "0",
	:shared=>"0",
	:IsSharedVessel=>"0",
	:vessels_types_id=>yacht.type,
	:lt_80 => (yacht.length.to_i < YC_LENGTH_THRESHOLD) ? "0" : "1",
	:used => yacht.used?,
	:vessels_manufacturers_id => "",
	:engines_manufacturers_id => "",
	:owner_id_id => "",
	:is_pending => "0",
	:hlt => "1",
	# inputs
	:name=>yacht.name,
	:vessel_manufacturer_name=>yacht.manufacturer,
	:vessels_categories_id => "",
	:built_in_year => yacht.year,
	:rigs_id=> "",
	:cockpit => "",
	:model=>yacht.model,
	:model_year=>yacht.year,
	:length_sys_id => DISTANCE_UNITS_TRANSFORM[yacht.length.units.to_sym][:yc],
	:length=>yacht.length.value,
#	:man_length=>yacht.length.value,
	:lod=>yacht.loa.to_s,
	:lwl=>yacht.lwl.to_s,
	:beam=>yacht.beam.to_s,
        :draft_min=>yacht.min_draft.to_s,
        :draft_max=>yacht.max_draft.to_s,
        :bridge_clearance=>yacht.bridge_clearance.to_s,
	:speed_sys_id => SPEED_UNITS_TRANSFORM[yacht.max_speed.units.to_sym][:yc],
        :cruise_speed=>yacht.cruise_speed.value,
        :max_speed=>yacht.max_speed.value,
	:weight_sys_id => WEIGHT_UNITS_TRANSFORM[yacht.ballast.units.to_sym][:yc],
        :displacement=>yacht.displacement.value,
        :ballase_weight=>yacht.ballast.value,
	:hull_materials_id=>MATERIAL_TRANSFORM[yacht.hull.material.to_sym][:yc],
	:hull_designer=>yacht.hull.designer,
	:volume_sys_id => VOLUME_UNITS_TRANSFORM[yacht.holding_tank.capacity.units.to_sym][:yc],
	:fuel_capacity=>yacht.fuel_tank.capacity.value,
        :water_capacity=>yacht.water_tank.capacity.value,
        :holding_tank=>yacht.holding_tank.capacity.value,
        :number_of_engines=>(0..4).include?(yacht.engines.length) ? yacht.engines.length : 1,
	:engines_manufacturers_name => engine.manufacturer,
        :engine_model=>engine.model,
	:fuel_types_id=>FUEL_TRANSFORM[engine.fuel.to_sym][:yc],
	:flag => "none",
        :city=>yacht.location.city,
#	:states_id=>YachtTransfer::Models::State.abbreviation(yacht.location.state),
#       :countries_id=>COUNTRY_TRANSFORM.keys.include?(yacht.location.country.to_sym) ? COUNTRY_TRANSFORM[yacht.location.country.to_sym][:yc] : yacht.location.country,
#	:regions_id=>"",
	:listing_types_id => LISTING_TYPE_TRANSFORM[listing.type.to_sym][:yc],
	:listing_statuses_id => STATUS_TRANSFORM[listing.status.to_sym][:yc],
	:ask_price_currency_id =>PRICE_UNITS_TRANSFORM[listing.price.units.to_sym][:yc],
	:ask_price => listing.price.value,
	:salesmans_id => listing.broker,
	:showing_instructions=>listing.contact_info,
	:description=>yacht.description,
	:vessels_entry_agreement => "1"})
	yacht.engines.each_with_index do |e, i|
	  params.merge!({
            "horse_power#{i+1}".to_sym => e.horsepower.to_s,
            "num_hours#{i+1}".to_sym =>e.hours})
	end
	params
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
	  :specs_access=>"PublicUsers",
          :builder=>yacht.manufacturer,
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
end

