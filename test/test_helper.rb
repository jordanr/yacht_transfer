require 'test/unit'
require 'rubygems'
require 'flexmock/test_unit'
require 'mocha'

$: << File.join(File.dirname(__FILE__), '..', 'lib')

RAILS_ROOT=File.join(File.dirname(__FILE__),'..','..')
require 'yacht_transfer'

class Test::Unit::TestCase
  private
  def fixture(string)
    File.open(File.dirname(__FILE__) + "/fixtures/#{string}").read
  end

  def sample_accommodation
    {:title=>"sample_title",:content=>"sample_content"}
  end
  def sample_engine
    {:manufacturer=>"smaple_manufacturer", :model=>"sample_model",
     :fuel=>"sample_fuel",:horsepower=>"sample_hp", :year=>"sample_year",
     :hours=>"sample_hourss"
    }
  end
  def sample_hull
    {:configuration=>"sample_configuration", :material=>"sample_material",
     :color=>"sample_color", :designer=>"sample_designer"
    }
  end
  def sample_location
    {:city=>"sample_city", :zip=>"sample_zip", :country=>"sample_country",
     :state=>"sample_state", :region=>"sample_region"
    }
  end
  def sample_measurement
    {:value=>"sample_value", :units=>"smaple_units"}
  end
  def sample_tank
    {:material=>"sample_material", :capacity=>"sample_capacity"}
  end
  def sample_picture
  end
  def sample_refit
  end
  def sample_user
  end
  def sample_yacht
    {:name=>"sample_name",:manufacturer=>"sample_manufacturer", 
     :model=>"sample_model", :category=>"sample_category",
     :rig=>"smaple_rig", :cockpit=>"sample_cockpit", 
     :flag=>"sample_flag",:number_of_staterooms=>"sample_staterooms",
     :new=>"sample_new", :power=>"sample_power", :year=>"sample_year",
     :length=>sample_measurement, :lwl=>sample_measurement, :loa=>sample_measurement,
     :beam=>sample_measurement, :min_draft=>sample_measurement, :max_draft=>sample_measurement,
     :bridge_clearance=>sample_measurement, :displacement=>sample_measurement,
     :ballast=>sample_measurement,:cruise_speed=>sample_measurement,:max_speed=>sample_measurement,
     :hull=>sample_hull,
     :fuel_tank=>sample_tank, :water_tank=>sample_tank, :holding_tank=>sample_tank,
     :location=>sample_location, 
     :accommodations=>[sample_accommodation, sample_accommodation],
     :engines=>sample_engine
    }

  end
  def sample_listing
    YachtTransfer::Models::Listing.new({:yacht=>sample_yacht, :price=>sample_measurement})
  end

  
  def expect_http_posts_with_responses(*responses_xml)
    mock_http = establish_session
    responses_xml.each do |xml_string|
      mock_http.should_receive(:post_form).and_return(xml_string).once.ordered(:posts)
    end   
  end
  
  def establish_session(session = @session)
    mock = flexmock(Net::HTTP).should_receive(:post_form).and_return(example_auth_token_xml).once.ordered(:posts)
    mock.should_receive(:post_form).and_return(example_get_session_xml).once.ordered(:posts)
    session.secure!    
    mock
  end
  
  def example_auth_token_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <auth_createToken_response xmlns="http://api.facebook.com/1.0/" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
        xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
        3e4a22bb2f5ed75114b0fc9995ea85f1
        </auth_createToken_response>    
    XML
  end
  
  def example_get_session_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <auth_getSession_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
      <session_key>5f34e11bfb97c762e439e6a5-8055</session_key>
      <uid>8055</uid>
      <expires>1173309298</expires>
      <secret>ohairoflamao12345</secret>
    </auth_getSession_response>    
    XML
  end  
end
