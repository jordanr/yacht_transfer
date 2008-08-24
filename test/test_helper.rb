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
#    Accommodation.new("
  end
  def sample_engine
  end
  def sample_hull
  end
  def sample_listing
  end
  def sample_location
  end
  def sample_measurement
  end
  def sample_picture
  end
  def sample_refit
  end
  def sample_tank
  end
  def sample_user
  end
  def sample_yacht
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
