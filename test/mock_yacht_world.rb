class ParameterError < StandardError; end

class MockResponse
  def initialize(body)
    @body = body
  end

  def body
    @body
  end
end

class MockYachtWorld

  def initialize
    @id_one = 1758881           
    @id_two = 1711800 
    @ids = [@id_one, @id_two]
#    @boat_id = 1966820
    @users = {'test'=>'test'}
  end  

  def index(params)
    return Net::HTTPSuccess.new('a', 'b', 'c')
  end  


  # GET "/boatwizard/listings/view_more_boat.cgi?boat_id=1758881
  # Read listing
  def view_more_boat(params)
    local_required_keys = %w{ boat_id }
    raise ParameterError, "bad local keys" unless valid_keys?(params, local_required_keys)

    return MockResponse.new("all about boat #{params[:boat_id]}")
  end    
  ##################
  # Listings
  ######################

  # POST "/boatwizard/lib/edit_sql.cgi"
  # Create, Edit Listing
  # Basic path
  def edit_sql(params)
    local_required_keys = %w{ revised_date old_price old_local_price old_currency first_price_change
			      action boats_clobs_id maker model central co_op length year price hin
			      units currency boat_type hin_unavail tax fuel engine_num hull_material
			      boat_new boat_city boat_state boat_country description contact_info
			      office_id broker_id full_specs }
    
    # in addition to Edit photos
    # edit_photos_keys = %w{ photo_description_order_x photo_sort_order_x }
    raise ParameterError, "bad local keys" unless valid_keys?(params, local_required_keys)

    # all or none
    raise ParameterError, "something wrong with combo: #{params[:boat_id]}, #{params[:action]}, #{params[:boats_clobs_id]}" unless
				(params[:boat_id] == "New" and params[:action]=="Add" and params[:boats_clobs_id] == "New") or
			        (@ids.include?(params[:boat_id]) and params[:action]=="Edit" and @ids.include?(params[:boats_clobs_id]))

    raise ParameterError unless params[:hin_unavail] == "on"
    # submit
    raise ParameterError unless params[:full_specs] == "Full Specs"

    id = params[:boat_id] == "New" ? @id_one : params[:boat_id]

    # year must be 4 digits 
 
    return MockResponse.new('<form name="fsform" id="fsform" method="post" action="/boatwizard/lib/edit2_sql.cgi">
<INPUT type="hidden" name="boat_id" value="'+id.to_s+'">
<INPUT type="hidden" name="url" value="jordanyacht">
<INPUT type="hidden" name="lang" value="en">
<INPUT type="hidden" name="revised_date" value="20080901">
<INPUT type="hidden" name="action" value="Edit">
<INPUT type="hidden" name="ops" id="ops" value="">
<input type=hidden name=pass_office_id value="">
<input type=hidden name=pass_broker_id value="">')
  end

  # GET "/boatwizard/lib/delete_sql.cgi"
  # Delete
  def delete_sql(params)
    local_required_keys = %w{ type min_length max_length units }
    raise ParameterError unless valid_keys?(params, local_required_keys)
    raise ParameterError, "boat_id should be #{@ids.join(',')} not #{params[:boat_id]}" unless @ids.include?(params[:boat_id].to_i)
  end

  #################
  # Details
  #################

  # POST "/boatwizard/lib/edit2_sql.cgi"
  # Create, Edit, Delete Details
  # Details path
  def edit2_sql(params)
    local_required_keys = %w{ action ops }

    # edit listing 
    edit_listing_keys = %w{ name_access name specs_access builder designer loa lwl
		    beam draft clearance displacement ballast engines engine_hp 
		    engine_model cruising_speed engine_hours max_speed fuel_tank 
		    water_tank holding_tank ad }
    # and edit details
    # edit_details_keys = %w{ clob_id_x desc_order_x clob_title_x description_access_x
    #		    clob_paragraph_x clob_left_x clob_right_x } 
    # and to delete details
    # delete_details_keys = %w{ delete_x }
 
    # create details 
    create_keys = %w{ add_desc }

    raise ParameterError unless valid_keys?(params, local_required_keys)

    raise ParameterError unless params[:action] == "Edit"
    raise ParameterError, "boat_id should be #{@ids.join(',')} not #{params[:boat_id]}" unless @ids.include?(params[:boat_id].to_i)

    if valid_keys?(params, edit_listing_keys)
      raise(ParameterError, "expected to edit listing") unless (params[:name_access] == "PublicUsers" and params[:specs_access]== "PublicUsers")
      raise(ParameterError, "expected submit value") unless (params[:ad] == "Display Ad")
    elsif valid_keys?(params, create_keys)
      raise(ParameterError, "expected to create detail") unless(params[:add_desc]=="Add a Description")
    else 
      raise(ParameterError, "unknown request for edit2_sql")
    end

  end

  #################
  # Photos
  #################

  # POST "/boatwizard/listings/upload_photo.cgi"
  # Create photo
  # Photo path
  def upload_photo(params)
    local_required_keys = %w{ submit photo action }

#        fileName_x
    raise ParameterError unless valid_keys?(params, local_required_keys)
  end

  # GET "/boatwizard/listings/photos.cgi"
  # Delete photo
  def photos(params)
    local_required_keys = %w{ photo action }
 
    raise ParameterError unless valid_keys?(params, local_required_keys)
  end

  private
    def global_required_keys; %w{ boat_id lang pass_office_id pass_broker_id url }; end

    def valid_keys?(params, required_keys)
      required_keys += global_required_keys
      required_keys.each { |key| print key unless params.has_key?(key.to_sym) }
      return required_keys.all? { |key| params.has_key?(key.to_sym) }
    end  
end



  #############
  # Doesn't do anythin ?
  # Start path
  # "/boatwizard/listings/edit_listing.cgi"
  #  def edit_listing
  # end

