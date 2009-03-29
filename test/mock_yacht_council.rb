class MockYachtCouncilResponse
  attr_reader :body, :location

  def initialize(body, location=nil, cookie=nil)
    @body = body
    @location = location
    @cookie = cookie || ""
  end

  def [](method)
    self.send(method.gsub("-", "_") )
  end

  def set_cookie
    @cookie
  end
end

class MockYachtCouncil

  ###########
  # Authentication
  ##########

  # POST "/login.asp?login=#{username}&password=#{password}"
  def login(params)
    MockYachtCouncilResponse.new("object moved", "company_home.asp", "session=session")
  end

  # GET "/company_home.asp"
  def company_home(params)
    MockYachtCouncilResponse.new("abc Logoff efg")
  end  

  ################
  # Listings
  #################

  # Create and Update
  # POST "/vessel_entry_step1.asp"
  def vessel_entry_step1(params)
      local_required_params = %w{ vessel_entry_step_frm_auto vessels_id member_company_id login_id shared IsSharedVessel vessels_types_id
	lt_80 vessels_manufacturers_id vessels_tops_id inter_designer exter_designer proj_manager MCA_compliant ISM_compliant
	classification class_type class_expiry garbage engines_manufacturers_id owner_id_id is_pending hlt
	name vessels_categories_id vessel_manufacturer_name rigs_id built_in_year cockpit model used model_year
	speed_sys_id length_sys_id cruise_speed length rmp_speed man_length max_speed lwl max_rmp_speed
	lod range beam draft_min weight_sys_id draft_max displacement bridge_clearance gross_tonnage
	ballase_weight refit_year ballase_type refit_type hull_configurations_id fuel_tank_materials_id
	hull_materials_id water_tank_materials_id deck_materials_id hull_color volume_sys_id
	hull_finished fuel_capacity hull_designer fuel_consumption hull_id fuel_consumption_rpm fuel_consumption_knot
	water_capacity holding_tank number_of_engines engines_types_id engines_manufacturers_name propulsion_types_id
	engine_model fuel_types_id horse_power1 horse_power2 horse_power3 horse_power4 eng_year1 eng_year2 eng_year3
	eng_year4 num_hours1 num_hours2 num_hours3 num_hours4 date_hours_reg1 date_hours_reg2 date_hours_reg3 date_hours_reg4
	overhaul_date1 overhaul_date2 overhaul_date3 overhaul_date4 overhaul_hours1 overhaul_hours2 overhaul_hours3 overhaul_hours4
	serial_number1 serial_number2 serial_number3 serial_number4 flag captain_on_board captain_name captain_phone city
	dock_master_name states_id dock_master_phone zip CG_doc_number countries_id state_reg_number regions_id n_of_staterooms n_of_crew_quarters
	n_of_berths n_of_crew_berths n_of_sleeps n_of_crew_sleeps n_of_heads n_of_crew_heads isFractional FracAmount AvailableFrac 
	listing_date ask_price_currency_id exp_date ask_price listing_types_id tax listing_statuses_id salesmans_id alt_listing_number owner_name 
	showing_instructions info description show_on_templates vessels_entry_agreement 
      }
      raise YachtCouncilError, "bad params #{params.inspect}" unless valid_keys?(params, local_required_params)

      # included ??
      # categories_types_id

      # for creation
      # x y

      # for updates
      #Update.x Update.y Update

      # Pre validate
      raise YachtCouncilError, "Broker name must not be empty" if params[:salesmans_id] == -1
      raise YachtCouncilError, "Boat Name is a required field, please enter a value" unless params[:name]
      raise YachtCouncilError, "Manufacturer/builder is a required field, please enter a value" unless params[:vessel_manufacturer_name]
      raise YachtCouncilError, "Year Built (YYYY) is a required field, please enter a value" unless params[:built_in_year]
      raise YachtCouncilError, "Model Year (yyyy) is a required field, please enter a value" unless params[:model_year]
      raise YachtCouncilError, "Category Type is a required field, please enter a value" unless params[:vessels_categories_id]
      raise YachtCouncilError, "Length is a required field, please enter a value" unless params[:length]
      raise YachtCouncilError, "Hull Material is a required field, please enter a value" unless params[:hull_materials_id]
      raise YachtCouniclError, "Flag is a required field, please enter a value" unless params[:flag]
      raise YachtCouncilError, "Vessel Region is a required field, please enter a value" unless params[:regions_id]
      raise YachtCouncilError, "Asking Price (no commas) is a required field, please enter a value" unless params[:ask_price]
      raise YachtCouncilError, "You can only select multiple subcategories on one Category." unless
      raise YachtCouncilError, "BUC Disclaimer Agreement is a required field. You must agree to the BUC disclaimer before adding this vessel. Sorry for the inconvenience." unless params[:vessels_entry_agreement]

      # Post validate
      errors = ""
      errors += "Please select a valid vessel manufacturer from our list" unless params[:vessel_manufacturer_name] == "Custom"
      errors += "Please select a valid engine manufacturer from our list" unless params[:engines_manufacturers_id] # and params[:engines_manufacturers_id] == "Custom"

      return MockYachtCouncilResponse.new(errors)
  end


  # Update
  # POST "/vessel-status-change.asp"
  def vessel_status_change
  end


  ##################
  # Details
  #################

  # Update
  # POST "/vessel-section-editor.aspx"
  def vessel_section_editor
    local_params = %w{  displayMode newMsgText form_FilterForm vessel section
			vessel-cahrter-flag vessel-sale-flag switch 
			section-editorid section-link-listSort section-link-listSortOrder
			show vesselMenuVesselName vesselMenuVesselForCharter vesselMenuVesselSalesman
			vesselMenuVesselCompany vesselMenuVesselCharterAgent backurl
			section_name house_only to_broker to_consumer section_text
			toolbarFirstLine_section_text toolbarSecondLine_section_text
			language_section_text savesection-editor
		     }
  end



  ###############
  # Photos
  ##############

  # Create, Update, Delete
  # POST "/media-uploader.aspx"
  def media_uploader
    local_params = %w{  displayMode form_media-uploader-form vessel video-editorid
			videos_count videos videosTableRowToMove virtual-tour-editorid
			vrtours_count vrtours vrtoursTableRowToMove sound-editorid
			sounds_count sounds switch vessel-picture-editorid 
			existing-file-names newMsgText show vesselMenuVesselOwner
			vesselMenuVesselName vesselMenuVesselForCharter vesselMenuVesselSalesman
			vesselMenuVesselCompany vesselMenuVesselCharterAgent backurl
			more-upload-picture section 
		     }

     # Create
#    (0..4).each do |i|
#		  {
 			# upload-pictureX upload-pictureX_fake descriptionX
#      			upload-picture0-brightness upload-picture0-contrast 
#			upload-picture0-saturation upload-picture0-rotate
#			upload-picture0-ctx upload-picture0-cty
#			upload-picture0-cbx upload-picture0-cby
#		  }
#      end
    # picturesX_count, picturesX

    # Delete
#    pictures-2editorXremove
#    pictures-2_remove

  end


  private
    def global_required_keys; %w{ }; end

    def valid_keys?(params, required_keys)
      required_keys += global_required_keys
      required_keys.each { |key| print key unless params.has_key?(key.to_sym) }
      return required_keys.all? { |key| params.has_key?(key.to_sym) }
    end

end

class YachtCouncilError < StandardError; end
