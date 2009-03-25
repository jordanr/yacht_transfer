require 'test/unit'
require 'rubygems'
#require 'flexmock/test_unit'
#require 'mocha'

$: << File.join(File.dirname(__FILE__), '..', 'lib')

RAILS_ROOT=File.join(File.dirname(__FILE__),'..','..')
require 'yacht_transfer'

class Test::Unit::TestCase
  private
  def picture_fixture(string)
#    ::File.open(File.dirname(__FILE__) + "/fixtures/#{string}", "rb") { |f| f.read }
    File.open(File.dirname(__FILE__) + "/fixtures/#{string}", "rb")
  end
  def fixture(string)
    File.open(File.dirname(__FILE__) + "/fixtures/#{string}").read
  end
  def write_fixture(filename, data)
    File.open(File.dirname(__FILE__) + "/fixtures/#{filename}", "w") << data
  end

  def sample_accommodation
    {:title=>"sample_title",:content=>"sample_content" }
  end
  def sample_picture
    {:label=>"sample picture", :src=>picture_fixture("rails.png")}
  end

  def sample_listing
    {:price=>1223, :yacht_name=>"sample_name",:yacht_specification_manufacturer=>"sample_manufacturer", 
     :yacht_specification_model=>"sample_model", :yacht_specification_year=>9999,
     :yacht_specification_length=>1, 
     :yacht_location=>"sample_location"
#     :details=>[sample_accommodation, sample_accommodation],
#     :photoss=>[sample_picture ,sample_picture,sample_picture]
    }
  end 


  #######################################################
  #######################################################
  def sample_engine
    {:manufacturer=>"smaple_manufacturer", :model=>"sample_model",
     :fuel=>"gas",:horsepower=>1000, :year=>1111,
     :hours=>100
    }
  end
  def sample_hull
    {:configuration=>"sample_configuration", :material=>"wood",
     :color=>"sample_color", :designer=>"sample_designer"
    }
  end
  def sample_location
    {:city=>"sample_city", :zip=>33315, :country=>"United States of America",
     :state=>"FL", :region=>"sample_region"
    }
  end
  def sample_price
    {:value=>1234, :units=>"euros"}
  end
  def sample_speed
    {:value=>12, :units=>"knots"}
  end
  def sample_distance
    {:value=>200, :units=>"meters"}
  end
  alias sample_measurement sample_distance
  def sample_weight
    {:value=>20, :units=>"tons"}
  end
  def sample_tank
    {:material=>"sample_material", :capacity=> { :value=>999, :units=>"liters"} }
  end
  def sample_yacht
    {:name=>"sample_name",:manufacturer=>"sample_manufacturer", 
     :model=>"sample_model", 
     :new=>"sample_new", :type=>"sail", :year=>9999,
     :length=>sample_measurement, :lwl=>sample_measurement, :loa=>sample_measurement,
     :beam=>sample_measurement, :min_draft=>sample_measurement, :max_draft=>sample_measurement,
     :bridge_clearance=>sample_measurement, :displacement=>sample_weight,
     :ballast=>sample_weight,:cruise_speed=>sample_speed,:max_speed=>sample_speed,
     :hull=>sample_hull,
     :fuel_tank=>sample_tank, :water_tank=>sample_tank, :holding_tank=>sample_tank,
     :location=>sample_location, 
     :accommodations=>[sample_accommodation, sample_accommodation],
     :engines=>[sample_engine, sample_engine],
     :pictures=>[sample_picture ,sample_picture,sample_picture]
    }
  end
  def old_sample_listing
    { :price=>sample_price, :broker=>"Dad", :type=>"open", 
	:status=>"in_progress", :co_op=>true,
 	:contact_info=>"sample_contact_info"}
  end

end
