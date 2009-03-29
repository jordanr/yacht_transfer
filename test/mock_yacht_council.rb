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

  # POST "/login.asp?login=#{username}&password=#{password}"
  def login(params)
    MockYachtCouncilResponse.new("object moved", "company_home.asp", "session=session")
  end

  # GET "/company_home.asp"
  def company_home(params)
    MockYachtCouncilResponse.new("abc Logoff efg")
  end
  
  # POST "/vessel_entry_step1.asp"
  def vessel_entry_step1
    local_params = %w{ vessel_entry_step_frm_auto vessels_id member_company_id login_id shared IsSharedVessel vessels_types_id
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
	showing_instructions info description show_on_templates vessels_entry_agreement Update.x Update.y Update
      }
end

  # POST "/vessel_status_change.asp"
  def vessel_status_change
  end

  # POST "/vessel_status_change.aspx"
  def media_uploader
    local_params = %w{  displayMode form_media-uploader-form vessel video-editorid
			videos_count videos videosTableRowToMove virtual-tour-editorid
			vrtours_count vrtours vrtoursTableRowToMove sound-editorid
			sounds_count sounds switch vessel-picture-editorid }
			
  end

  # POST "/vessel-section-editor.aspx"
  def vessel_section_editor
  end

end
