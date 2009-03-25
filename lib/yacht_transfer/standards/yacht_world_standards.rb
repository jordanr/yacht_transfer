# Extend hash to handle yw + yc param transforms.
class Hash
  include YachtTransfer::Standards::BaseStandards

  attr_reader :basic, :details, :photo

  def to_yw!
    @basic = default_params
    @basic.merge!(default_basic_params)
    (required_basic_params + required_params).each { |key| @basic.merge!(key_transform(key, :yw).to_sym => fetch(key.to_sym) ) }

    @details = default_params
    @details.merge!(default_details_params)
    (required_details_params + required_params).each { |key| @details.merge!(key_transform(key, :yw).to_sym => fetch(key.to_sym) ) }
    @details.merge!(:builder=>fetch(:yacht_specification_manufacturer))
  end


  private

  def default_params
    {
        :lang=>"en",
        :pass_office_id=>"",
        :pass_broker_id=>""
    }
  end

  def required_params
    %w{ username }
  end
  ###################
  # Basic
  ####################

  def default_basic_params
    { 	:old_price=>"",
	:old_local_price=>"",
	:old_currency=>"",
	:first_price_change=>"1",
        :revised_date=>Time.now.strftime("%Y%m%d"),
   	:hin=>"",
   	:hin_unavail=>"on",
        :tax=>"",

	:action=> "Add", # Edit
	:boat_id=> "New", # id
	:boats_clobs_id=> "New", # id
 
        :central=>"1",
	:co_op=>"1",
	:units=>"Feet",
        :currency=>"USD",
        :boat_type=>"", # ?
	:engine_num=>"1",
	:hull_material=>"O",
        :fuel=>"Other",
	:boat_new=>"Used",
	:boat_state=>"",
	:boat_country=>"",
	:description=>"",
	:contact_info=>"",
	:office_id=>"", # get ids?
	:broker_id=>"", # get ids?
	:full_specs=>"Full Specs" # submit
    }
  end

  def required_basic_params
#   	%w{ length maker model year price boat_city
	%w{ yacht_specification_length yacht_specification_manufacturer
	    yacht_specification_model yacht_specification_year
	    price yacht_location
	  }
  end

  def required_details_params
        %w{ id yacht_name }
  end

  def default_details_params
    {	
    	:action=>"Edit",
	:ops=>"",
#	:save_default_access=>"1", # never
	:name_access=>"PublicUsers",
	:specs_access=>"PublicUsers",
#       :builder=>"", #????
	:designer=>"",
	:loa=>"",
	:lwl=>"",
	:beam=>"",
        :draft=>"",
        :clearance=>"",
        :displacement=>"",
        :ballast=>"",
        :engines=>"",#engine.manufacturer,
        :engine_hp=>"",
        :engine_model=>"",
        :cruising_speed=>"",
        :engine_hours=>"",
        :max_speed=>"",
        :fuel_tank=>"",
        :water_tank=>"",
        :holding_tank=>"",
#	:specs_default=>"1", # never
	:ad=>"Display Ad" # submit
    }
  end

#	a = yacht.accommodations
#	clob_ids.each_with_index do |i, n|
#	  x = n+1
#	  params.merge!({
#		"clob_id_#{x}"=> i, # get ids?
#		"desc_order_#{x}"=>x, # ?
#		"clob_title_#{x}"=>a[n]? a[n].title : "",
#		"description_access_#{x}"=>"PublicUsers", # ?
#		"clob_paragraph_#{x}"=>a[n] ? a[n].content : "",
#		"clob_left_#{x}"=>a[n] ? a[n].left : "",
#		"clob_right_#{x}"=>a[n] ? a[n].right : ""
#	  })
#	  params.merge!({"delete_#{x}"=> "1"}) if !a[n]
#	end
#	params
 #     end


end

module YachtTransfer
  module Standards
    module YachtWorldStandards
	include BaseStandards
      YW_MAX_PHOTOS_TO_UPLOAD_AT_A_TIME = 5


      def yw_add_accommodation_params(id)
	params = yw_params
	params.merge!({
          :boat_id=>id ? id : raise(StandardError, "need boat id"),
    	  :action=>"Edit",
	  :ops=>"",
	  :add_desc=>"Add a Description"
	})
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
end

