require 'yacht_transfer/standards/base_standards'

module YachtTransfer
module Standards
class YachtCouncilHash < Hash
  include YachtTransfer::Standards::BaseStandards
  
  YC_LENGTH_THRESHOLD = 70
  YC_ENGINES = 4
  YC_MAX_PHOTOS = 5
  
  attr_reader :basic, :details, :photo

  def initialize(hash)
    hash.each_pair { |k, v| store(k,v)}
  end

  def to_yc!
    @basic = default_params
    @basic.merge!(default_basic_params)
    (required_basic_params + required_params).each { |key| @basic.merge!(key_transform(key, :yc).to_sym => fetch(key.to_sym) ) }
    @basic.merge!(:model_year=>fetch(:yacht_specification_year))
    @basic.merge!(:model => "#{fetch(:yacht_specification_manufacturer)} #{fetch(:yacht_specification_model)}" )

    # create
    if has_key?(:id) and fetch(:id) != "0"
      @basic.merge!({:Update => "Update", "Update.x".to_sym => "23", "Update.y".to_sym =>"10"})
      @basic.merge!({:MCA_compliant=> "False", :ISM_compliant=> "False" })
    else
      @basic.merge!({:x => "1", :y=>"1"})
    end

    
#    @details = default_params
#    @details.merge!(default_details_params)
#    (required_details_params + required_params).each { |key| @details.merge!(key_transform(key, :yc).to_sym => fetch(key.to_sym) ) }
#    @details.merge!(:builder=>fetch(:yacht_specification_manufacturer))


    if has_key?(:id) and fetch(:id) != "0"
       @photo = default_params
       @photo.merge!(default_photo_params)
    end
  end

  private

    def below?
      fetch(:yacht_specification_length).to_i < YC_LENGTH_THRESHOLD
    end

    def default_params
      {
      }
    end

    def required_params
      %w{ }
    end
  ###################
  # Basic
  ####################


  # sail, used
  def default_basic_params
    res = { 	

  	  :member_company_id=>fetch(:member_company_id), #company_id,
  	  :login_id=>fetch(:login_id), #login_id
  	  :salesmans_id => fetch(:broker_id), #"3910",# listing.broker, # cache ids-- how?

	  :vessels_id=>has_key?(:id) ? fetch(:id) : "0",

	  # used/new
	  :used => "0", #??

	  :inter_designer=>"",
	  :exter_designer=>"",
	  :proj_manager=>"",
	  :class_type=>"",
	  :class_expiry=>"",
	  :cockpit=>"0",
	  :vessels_tops_id=>"",

	  # power
#	  :categories_types_id=>"1", 
#	  :vessels_categories_id=>"", 
#  	  :vessels_types_id=>"2", # YACHT_TYPE_TRANSFORM[yacht.type.to_sym][:yc],

	  # sail
  	  :vessels_types_id=>"1", # YACHT_TYPE_TRANSFORM[yacht.type.to_sym][:yc],
	  :vessels_categories_id => "1", 
	  :rigs_id=> "",
          :ballase_weight=>"", # spec

	  # length
	  :lt_80 => below? ? "0" : "1",
	  :MCA_compliant=> below? ? "" : "0", #False?
	  :ISM_compliant=> below? ? "" : "0", # False?
	  :classification=>below? ? "" : "7",

	  :vessel_entry_step_frm_auto=>"1",
	  :shared=>"0",
  	  :IsSharedVessel=>"0",
	  :garbage=>"",
	  :owner_id_id => "",
	  :is_pending => "0",
	  :hlt => "1", # 7 ??

	  :length_sys_id => "0", # DISTANCE_UNITS_TRANSFORM[yacht.length.units.to_sym][:yc],
	  :speed_sys_id =>"1", # SPEED_UNITS_TRANSFORM[yacht.max_speed.units.to_sym][:yc],
   	  :weight_sys_id =>"0", # WEIGHT_UNITS_TRANSFORM[yacht.ballast.units.to_sym][:yc],
	  :volume_sys_id => "0", #VOLUME_UNITS_TRANSFORM[yacht.holding_tank.capacity.units.to_sym][:yc],


  	  :man_length=>"",#yacht.length.value,
	  :lwl=>"", # yacht.lwl.to_s,
	  :lod=>"", #yacht.loa.to_s,
	  :beam=>"", #yacht.beam.to_s,
          :draft_min=>"", #yacht.min_draft.to_s,
          :draft_max=>"", #yacht.max_draft.to_s,
          :bridge_clearance=> "", #yacht.bridge_clearance.to_s,
	  :refit_year=>"",
	  :refit_type=>"",
          :cruise_speed=>"", #yacht.cruise_speed.value,
	  :rmp_speed => "",
          :max_speed=>"", #yacht.max_speed.value,
	  :max_rmp_speed => "",
	  :range=>"",
          :displacement=>"", #yacht.displacement.value,

	  :hull_configurations_id=>"",
  	  :hull_materials_id=>"7", #MATERIAL_TRANSFORM[yacht.hull.material.to_sym][:yc],
	  :deck_materials_id=>"",
	  :hull_color=>"",
	  :hull_finished=>" ",
  	  :hull_designer=>"", #yacht.hull.designer,
	  :hull_id=>"",
	  :fuel_tank_materials_id =>"",
	  :water_tank_materials_id =>"",
  	  :fuel_capacity=>"", #yacht.fuel_tank.capacity.value,
	  :fuel_consumption=>"",
	  :fuel_consumption_rpm=>"",
	  :fuel_consumption_knot=>"",
          :water_capacity=>"", #yacht.water_tank.capacity.value,
          :holding_tank=>"", #yacht.holding_tank.capacity.value,

          :number_of_engines=>"1", #(0..4).include?(yacht.engines.length) ? yacht.engines.length : 1,
	  :engine_types_id=>"",
	  :propulsion_types_id=>"",
  	  :fuel_types_id=>"",#FUEL_TRANSFORM[engine.fuel.to_sym][:yc],

	  :flag => "none",
  	  :states_id=>"61", #YachtTransfer::Models::State.abbreviation(yacht.location.state),
	  :zip=>"",
          :countries_id=>"", #COUNTRY_TRANSFORM.keys.include?(yacht.location.country.to_sym) ? COUNTRY_TRANSFORM[yacht.location.country.to_sym][:yc] : yacht.location.country,
  	  :regions_id=>"70", #other,other
	  :captain_on_board=>"False",
	  :captain_name=>"",
	  :captain_phone=>"",
	  :dock_master_name=>"",
	  :dock_master_phone=>"",
	  :CG_doc_number=>"",
	  :state_reg_number=>"",
	  :n_of_staterooms=>" ",#0
	  :n_of_berths=>"0",
	  :n_of_sleeps=>"0",
	  :n_of_heads=>"0",
	  :n_of_crew_quarters=>" ", #0
	  :captain_quarters=>"",
	  :n_of_crew_berths=>"0",
	  :n_of_crew_sleeps=>"0",
	  :n_of_crew_heads=>"0",
	
	  :listing_date=>Time.now.strftime("%m/%d/%Y"), # ex. 12/25/2008
	  :exp_date=>"",
  	  :listing_types_id =>"10", # LISTING_TYPE_TRANSFORM[listing.type.to_sym][:yc],
 	  :listing_statuses_id =>"7",# STATUS_TRANSFORM[listing.status.to_sym][:yc],
	  :alt_listing_number=>"",
	  :isFractional=>"0",
	  :FracAmount=>"",
  	  :ask_price_currency_id => "7", # PRICE_UNITS_TRANSFORM[listing.price.units.to_sym][:yc],
	  :poa_price=>"",
	  :tax=>"0",
	  :owner_name=>"",
	  :showing_instructions=>"", #listing.contact_info,
	  :info=>"",
 	  :description=>"", #yacht.description,
	  :show_on_templates=>"1",
	  :AvailableFrac=>"",
	  :model_year=>"",
	  :gross_tonnage=>"",
	  :ballase_type=>"0",
	  :engines_types_id=>"",
	  :vessel_manufacturer_name=>"Custom",
	  :vessels_manufacturers_id => "641",
	  :engines_manufacturers_name=>"Upon Request",
  	  :engines_manufacturers_id => "245",
	  :engine_model=>"",
  	  :vessels_entry_agreement => "1"
  	  }

    (0...YC_ENGINES).each do |i|
      res.merge!({
              "horse_power#{i+1}".to_sym => "", #e.horsepower.to_s,
              "eng_year#{i+1}".to_sym => "",
              "num_hours#{i+1}".to_sym => "", #e.hours,
              "date_hours_reg#{i+1}".to_sym => "",
              "overhaul_hours#{i+1}".to_sym => "",
	      "overhaul_date#{i+1}".to_sym=>"",
              "serial_number#{i+1}".to_sym => ""
      })
    end
    res
  end

  def required_basic_params
	%w{ yacht_specification_length yacht_specification_year
	    price yacht_location yacht_name
	  }
  end

  def required_details_params
        %w{ id yacht_name }
  end

  def default_details_params
    {	
    }
  end

  def default_photo_params
    params = {  :displayMode=>"",
		"form_media-uploader-form".to_sym=>"1",
		:vessel=>fetch(:id),
		"video-editorid".to_sym=>fetch(:id),
                :videos_count=>"0",
		:videos =>"1",
		:videosTableRowToMove =>"",
		"virtual-tour-editorid".to_sym=>fetch(:id),
                :vrtours_count =>"0",
		:vrtours =>"1",
		:vrtoursTableRowToMove=>"",
		"sound-editorid".to_sym =>fetch(:id),
                :sounds_count =>"0",
		:sounds =>"1",
		:switch =>"vessel-picture-editor",
		"vessel-picture-editorid".to_sym =>fetch(:id),
                "existing-file-names".to_sym =>"",
		:newMsgText =>"New message",
		:show =>"",
		:vesselMenuVesselOwner=>"",
                :vesselMenuVesselName => fetch(:yacht_name),
		:vesselMenuVesselForCharter => "",
		:vesselMenuVesselSalesman => fetch(:broker_id), 
                :vesselMenuVesselCompany => fetch(:member_company_id),
		:vesselMenuVesselCharterAgent =>"",
		:backurl=>"",
                "more-upload-picture".to_sym => "",
		:section => "-2",
		"images-upload-button".to_sym => "Upload"
    }
     # Create
    (0..4).each do |i|
      params.merge!({
                        "upload-picture#{i}".to_sym => fetch(:photos)[i] ? fetch(:photos)[i][:src] : "",
			"upload-picture#{i}_fake" => "",
			"description#{i}" => fetch(:photos)[i] ? fetch(:photos)[i][:label] : "",
                        "upload-picture#{i}-brightness".to_sym=> "50",
			"upload-picture#{i}-contrast".to_sym => "50",
                        "upload-picture#{i}-saturation".to_sym => "50",
			"upload-picture#{i}-rotate".to_sym => "0",
                        "upload-picture#{i}-ctx".to_sym => "0",
			"upload-picture#{i}-cty".to_sym => "0",
                        "upload-picture#{i}-cbx".to_sym => "100",
			"upload-picture#{i}-cby".to_sym => "100"
                  })
    end
    # picturesX_count, picturesX
    # Delete
    #    pictures-2editorXremove
    #    pictures-2_remove
    params
  end



end
end
end
