require 'yacht_transfer/standards/base_standards'
module YachtTransfer
  module Standards
    module YachtCouncilStandards
	include BaseStandards
      YC_LENGTH_THRESHOLD = 70

      def below?(yacht)
	(yacht.length.to_i < YC_LENGTH_THRESHOLD)
      end

      def yc_hidden_used_params
	 { :used => yacht.used?}
      end

      def yc_hidden_new_params
	{}
      end

      def yc_hidden_above_params
        {}
      end

      def yc_hidden_below_params
	{
	  :inter_designer=>"",
	  :exter_designer=>"",
	  :proj_manager=>"",
	  :MCA_compliant=>"",
	  :ISM_compliant=>"",
	  :classification=>"",
	  :class_type=>"",
	  :class_expiry=>""
	}
      end
	  
      def yc_hidden_power_params
	{  :vessels_categories_id=>"", :cockpit=>""}
      end

      def yc_hidden_sail_params
	{:vessels_tops_id=>""}
      end

      def yc_params(listing, id) # , company_id, login_id)
	params = {
  	  :vessels_entry_step_frm_auto=>"1",	
	  :vessels_id=>id ? id : "0",
  	  :member_company_id=>"", #company_id,
  	  :login_id=>"", #login_id,
	  :shared=>"0",
  	  :IsSharedVessel=>"0",
  	  :vessels_types_id=>YACHT_TYPE_TRANSFORM[yacht.type.to_sym][:yc],
	  :lt_80 => below?(yacht) ? "0" : "1",
	  :vessels_manufacturers_id => "",
	  :garbage=>"",
  	  :engines_manufacturers_id => "",
	  :owner_id_id => "",
	  :is_pending => "0",
	  :hlt => "1",
        }
	params.merge!(below?(yacht) ? yc_hidden_below_params : yc_hidden_above_params)
	params.merge!(yacht.sail? ? yc_hidden_sail_params : yc_hidden_power_params)
	params.merge!(yacht.used? ? yc_hidden_used_params : yc_hidden_new_params)
	params
      end

      def yc_basic_used_params
	{}
      end

      def yc_basic_new_params
	{ :used => yacht.used? }
      end
      def yc_basic_above_params
        {
  	  :inter_designer=>"",
	  :exter_designer=>"",
	  :proj_manager=>"",
	  :MCA_compliant=>"0",
	  :ISM_compliant=>"0",
	  :classification=>"7",
	  :class_type=>"",
	  :class_expiry=>""
	}
      end

      def yc_basic_below_params
	{}
      end
	  
      def yc_basic_power_params
	{
	  :categories_types_id=>"1",
	  :vessels_tops_id =>""
	}
      end

      def yc_basic_sail_params(yacht)
	{
	  :vessels_categories_id => "1",
	  :rigs_id=> "",
	  :cockpit => "",
          :ballase_weight=>yacht.ballast.value,
	}
      end

      def yc_basic_params(listing, id)
	yacht = listing.yacht
	engine = yacht.engines.first
	params = yc_params
	params.merge!(below?(yacht) ? yc_basic_below_params : yc_basic_above_params)
	params.merge!(yacht.sail? ? yc_basic_sail_params : yc_basic_power_params)
	params.merge!(yacht.used? ? yc_basic_used_params : yc_basic_new_params)
	params.merge!({
 	  :name=>yacht.name,
	  :vessel_manufacturer_name=>yacht.manufacturer,
	  :built_in_year => yacht.year,
	  :model=>yacht.model,
	  :model_year=>yacht.year,

	  :length_sys_id => DISTANCE_UNITS_TRANSFORM[yacht.length.units.to_sym][:yc],
	  :length=>yacht.length.value,
  	  :man_length=>"",#yacht.length.value,
	  :lwl=>yacht.lwl.to_s,
	  :lod=>yacht.loa.to_s,
	  :beam=>yacht.beam.to_s,
          :draft_min=>yacht.min_draft.to_s,
          :draft_max=>yacht.max_draft.to_s,
          :bridge_clearance=>yacht.bridge_clearance.to_s,
	  :refit_year=>"",
	  :refit_type=>"",
	  :speed_sys_id => SPEED_UNITS_TRANSFORM[yacht.max_speed.units.to_sym][:yc],
          :cruise_speed=>yacht.cruise_speed.value,
	  :rmp_speed => "",
          :max_speed=>yacht.max_speed.value,
	  :max_rmp_speed => "",
	  :range=>"",
   	  :weight_sys_id => WEIGHT_UNITS_TRANSFORM[yacht.ballast.units.to_sym][:yc],
          :displacement=>yacht.displacement.value,

	  :hull_configurations_id=>"",
  	  :hull_materials_id=>MATERIAL_TRANSFORM[yacht.hull.material.to_sym][:yc],
	  :deck_materials_id=>"",
	  :hull_color=>"",
	  :hull_finished=>"",
  	  :hull_designer=>yacht.hull.designer,
	  :hull_id=>"",
	  :fuel_tank_materials_id =>"",
	  :water_tank_materials_id =>"",
	  :volume_sys_id => VOLUME_UNITS_TRANSFORM[yacht.holding_tank.capacity.units.to_sym][:yc],
  	  :fuel_capacity=>yacht.fuel_tank.capacity.value,
	  :fuel_consumption=>"",
	  :fuel_consumption_rpm=>"",
	  :fuel_consumption_knot=>"",
          :water_capacity=>yacht.water_tank.capacity.value,
          :holding_tank=>yacht.holding_tank.capacity.value,

          :number_of_engines=>(0..4).include?(yacht.engines.length) ? yacht.engines.length : 1,
  	  :engines_manufacturers_name => engine.manufacturer,
          :engine_model=>engine.model,
	  :engine_types_id=>"",
	  :propulsion_types_id=>"",
  	  :fuel_types_id=>FUEL_TRANSFORM[engine.fuel.to_sym][:yc],

	  :flag => "none",
          :city=>yacht.location.city,
  	  :states_id=>"", #YachtTransfer::Models::State.abbreviation(yacht.location.state),
	  :zip=>"",
          :countries_id=>"", #COUNTRY_TRANSFORM.keys.include?(yacht.location.country.to_sym) ? COUNTRY_TRANSFORM[yacht.location.country.to_sym][:yc] : yacht.location.country,
  	  :regions_id=>"70", #other,other
	  :captain_on_board=>"",
	  :captain_name=>"",
	  :captain_phone=>"",
	  :dock_master_name=>"",
	  :dock_master_phone=>"",
	  :CG_doc_number=>"",
	  :state_reg_number=>"",
	  :n_of_staterooms=>"",
	  :n_of_berths=>"",
	  :n_of_sleeps=>"",
	  :n_of_heads=>"",
	  :n_of_crew_quarters=>"",
	  :captain_quarters=>"",
	  :n_of_crew_berths=>"",
	  :n_of_crew_sleeps=>"",
	  :n_of_crew_heads=>"",
	
	  :listing_date=>"", # ex. 12/25/2008
	  :exp_date=>"",
  	  :listing_types_id => LISTING_TYPE_TRANSFORM[listing.type.to_sym][:yc],
 	  :listing_statuses_id => STATUS_TRANSFORM[listing.status.to_sym][:yc],
	  :alt_listing_number=>"",
	  :isFractional=>"0",
	  :FracAmount=>"",
  	  :ask_price_currency_id =>PRICE_UNITS_TRANSFORM[listing.price.units.to_sym][:yc],
  	  :ask_price => listing.price.value, #no commas
	  :poa_price=>"",
	  :tax=>"0",
  	  :salesmans_id => listing.broker, # cache ids-- how?
	  :owner_name=>"",
	  :showing_instructions=>listing.contact_info,
	  :info=>"",
 	  :description=>yacht.description,
	  :show_on_templates=>"1",
  	  :vessels_entry_agreement => "1"})
	yacht.engines.each_with_index do |e, i|
	  params.merge!({
            "horse_power#{i+1}".to_sym => e.horsepower.to_s,
            "engine_year#{i+1}".to_sym => "",
            "num_hours#{i+1}".to_sym =>e.hours,
            "date_hours_reg#{i+1}".to_sym => "",
            "overhaul_hours#{i+1}".to_sym => "",
            "serial_number#{i+1}".to_sym => ""
	  })
	end
	params
      end
    end
  end
end

