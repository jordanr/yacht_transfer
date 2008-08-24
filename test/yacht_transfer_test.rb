require File.dirname(__FILE__) + '/test_helper.rb'
class TestYachtTransfer < Test::Unit::TestCase
  def setup
    @yc_username = "jys"
    @yc_password = "yacht"
    @yc = Js2Fbjs::Uploaders::YachtCouncilUploader.new(@yc_username, @yc_password)

    @yw_username = "jordanyacht"
    @yw_password = "swel4roj"
    @yw = Js2Fbjs::Uploaders::YachtWorldUploader.new(@yw_username, @yw_password)
    @yw_start_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_start_page.html"))
  end

  def test_login_must_be_overridden
    upper = Js2Fbjs::Uploaders::BaseUploader.new("a","b")
    assert_raises(Js2Fbjs::Uploaders::BaseUploader::NotImplementedError) { upper.login }
  end

  def test_get_form_true
    assert @yw.get_form(@yw_start_page, "maker")
  end

  def test_get_form_false
    assert_raises(Js2Fbjs::Uploaders::BaseUploader::FormNotFoundError) { @yw.get_form(@yw_start_page, "makesr") }
  end

################### 
##  Take too long
  def do_not_test_yacht_council_logon
    assert @yc.login
  end

  def do_not_test_yacht_council_logon_fails
    yc = Js2Fbjs::Uploaders::YachtCouncilUploader.new("dkad", "dddd")
    assert_raises(Js2Fbjs::Uploaders::BaseUploader::LoginFailedError) { yc.login }
  end

  def test_yacht_world_logon
    assert @yw.login
  #  p @yw_start_page.forms
  #  File.open("yw_test", "w") << x
  end

  def do_not_test_yacht_world_logon_fails
    yw = Js2Fbjs::Uploaders::YachtWorldUploader.new("dkad", "dddd")
    assert_raises(Js2Fbjs::Uploaders::BaseUploader::LoginFailedError) { yw.login }
  end
################

  private
  def populate_user_info
    mock_http = establish_session
    mock_http.should_receive(:post_form).and_return(example_user_info_xml).once
    @session.user.populate
  end

  def populate_user_info_with_limited_fields
    mock_http = establish_session
    mock_http.should_receive(:post_form).and_return(example_limited_user_info_xml).once.ordered(:posts)
    @session.user.populate(:affiliations, :status, :meeting_for)
  end
  
  def populate_session_friends
    mock_http = establish_session
    mock_http.should_receive(:post_form).and_return(example_friends_xml).once.ordered(:posts)
    mock_http.should_receive(:post_form).and_return(example_user_info_xml).once.ordered(:posts)
    @session.user.friends!    
  end
  
  def populate_session_friends_with_limited_fields
    mock_http = establish_session
    mock_http.should_receive(:post_form).and_return(example_friends_xml).once.ordered(:posts)
    mock_http.should_receive(:post_form).and_return(example_limited_user_info_xml).once.ordered(:posts)
    @session.user.friends!(:affiliations, :status, :meeting_for)    
  end
  
  def sample_args_to_post
    {:method=>"facebook.auth.createToken", :sig=>"18b3dc4f5258a63c0ad641eebd3e3930"}
  end  
  
  def example_set_fbml_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
      <profile_setFBML_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">1</profile_setFBML_response>    
    XML
  end
  
  def example_get_fbml_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <profile_getFBML_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
    &lt;fb:if-is-own-profile&gt;My profile!
    &lt;fb:else&gt; Not my profile!&lt;/fb:else&gt;
    &lt;/fb:if-is-own-profile&gt;
    </profile_getFBML_response>    
    XML
  end
  
  def example_notifications_send_xml
    <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<notifications_send_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">http://www.facebook.com/send_email.php?from=211031&id=52</notifications_send_response>
    XML
  end     
  
	  def example_notifications_send_email_xml
	    <<-XML
	    <?xml version="1.0" encoding="UTF-8"?>
	<notifications_sendEmail_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">123,321</notifications_sendEmail_response>
	    XML
	  end

  def example_request_send_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <notifications_sendRequest_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">http://www.facebook.com/send_req.php?from=211031&id=6</notifications_sendRequest_response>    
    XML
  end  
  
  def example_notifications_get_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <notifications_get_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <messages>
        <unread>1</unread>
        <most_recent>1170644932</most_recent>
      </messages>
      <pokes>
        <unread>0</unread>
        <most_recent>0</most_recent>
      </pokes>
      <shares>
        <unread>1</unread>
        <most_recent>1170657686</most_recent>
      </shares>
      <friend_requests list="true">
        <uid>2231342839</uid>
        <uid>2231511925</uid>
        <uid>2239284527</uid>
      </friend_requests>
      <group_invites list="true"/>
      <event_invites list="true"/>
    </notifications_get_response>    
    XML
  end
  
  def example_publish_story_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <feed_publishStoryToUser_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">1</feed_publishStoryToUser_response>    
    XML
  end
  
  def example_publish_action_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <feed_publishActionOfUser_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">1</feed_publishActionOfUser_response>    
    XML
  end
    
  def example_publish_templatized_action_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <feed_publishTemplatizedAction_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <feed_publishTemplatizedAction_response_elt>1</feed_publishTemplatizedAction_response_elt>
    </feed_publishTemplatizedAction_response>
    XML
  end
  
  def example_user_info_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <users_getInfo_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <user>
        <uid>222333</uid>
        <about_me>This field perpetuates the glorification of the ego.  Also, it has a character limit.</about_me>
        <activities>Here: facebook, etc. There: Glee Club, a capella, teaching.</activities>
        <affiliations list="true">
          <affiliation>
            <nid>50453093</nid>
            <name>Facebook Developers</name>
            <type>work</type>
            <status/>
            <year/>
          </affiliation>
        </affiliations> 
        <birthday>November 3</birthday>
        <books>The Brothers K, GEB, Ken Wilber, Zen and the Art, Fitzgerald, The Emporer's New Mind, The Wonderful Story of Henry Sugar</books>
        <current_location>
          <city>Palo Alto</city>
          <state>CA</state>
          <country>United States</country>
          <zip>94303</zip>
        </current_location>
        <education_history list="true">
          <education_info>
            <name>Harvard</name>
            <year>2003</year>
            <concentrations list="true">
              <concentration>Applied Mathematics</concentration>
              <concentration>Computer Science</concentration>
            </concentrations>
            <degree>Masters</degree>
          </education_info>
        </education_history>
        <first_name>Dave</first_name>
         <hometown_location>
           <city>York</city>
           <state>PA</state>
           <country>United States</country>
           <zip>0</zip>
         </hometown_location>
         <hs_info>
           <hs1_name>Central York High School</hs1_name>
           <hs2_name/>
           <grad_year>1999</grad_year>
           <hs1_id>21846</hs1_id>
           <hs2_id>0</hs2_id>
         </hs_info>
         <is_app_user>1</is_app_user>
         <has_added_app>1</has_added_app>
         <interests>coffee, computers, the funny, architecture, code breaking,snowboarding, philosophy, soccer, talking to strangers</interests>
         <last_name>Fetterman</last_name>
         <meeting_for list="true">
           <seeking>Friendship</seeking>
         </meeting_for>
         <meeting_sex list="true">
           <sex>female</sex>
         </meeting_sex>
         <movies>Tommy Boy, Billy Madison, Fight Club, Dirty Work, Meet the Parents, My Blue Heaven, Office Space </movies>
         <music>New Found Glory, Daft Punk, Weezer, The Crystal Method, Rage, the KLF, Green Day, Live, Coldplay, Panic at the Disco, Family Force 5</music>
         <name>Dave Fetterman</name>
         <notes_count>0</notes_count>
         <pic>http://photos-055.facebook.com/ip007/profile3/1271/65/s8055_39735.jpg</pic>
         <pic_big>http://photos-055.facebook.com/ip007/profile3/1271/65/n8055_39735.jpg</pic_big>
         <pic_small>http://photos-055.facebook.com/ip007/profile3/1271/65/t8055_39735.jpg</pic_small>
         <pic_square>http://photos-055.facebook.com/ip007/profile3/1271/65/q8055_39735.jpg</pic_square>
         <political>Moderate</political>
         <profile_update_time>1170414620</profile_update_time>
         <quotes/>
         <relationship_status>In a Relationship</relationship_status>
         <religion/>
         <sex>male</sex>
         <significant_other_id xsi:nil="true"/>
         <status>
           <message>I rule</message>
           <time>0</time>
         </status>
         <timezone>-8</timezone>
         <tv>cf. Bob Trahan</tv>
         <wall_count>121</wall_count>
         <work_history list="true">
           <work_info>
             <location>
               <city>Palo Alto</city>
               <state>CA</state>
               <country>United States</country>
             </location>
             <company_name>Facebook</company_name>
             <position>Software Engineer</position>
             <description>Tech Lead, Facebook Platform</description>
             <start_date>2006-01</start_date>
             <end_date/>
            </work_info>
         </work_history>
       </user>
       <user>
         <uid>1240079</uid>
         <about_me>I am here.</about_me>
         <activities>Party.</activities>       
       </user>
    </users_getInfo_response>    
    XML
  end

  def example_limited_user_info_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <users_getInfo_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <user>
        <uid>222333</uid>
        <affiliations list="true">
          <affiliation>
            <nid>50453093</nid>
            <name>Facebook Developers</name>
            <type>work</type>
            <status/>
            <year/>
          </affiliation>
        </affiliations> 
         <meeting_for list="true">
           <seeking>Friendship</seeking>
         </meeting_for>
         <status>
           <message>I rule</message>
           <time>0</time>
         </status>
       </user>
       <user>
         <uid>1240079</uid>
         <activities>Party.</activities>       
       </user>
    </users_getInfo_response>    
    XML
  end

  
  def example_friends_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <friends_get_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <uid>222333</uid>
      <uid>1240079</uid>
    </friends_get_response>
    XML
  end
  
  def example_friend_lists_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <friends_getLists_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <friendlist>
    		<flid>12089150545</flid>
    		<name>Family</name>
  		</friendlist>
  		<friendlist>
    		<flid>16361710545</flid>
    		<name>Entrepreneuer</name>
  		</friendlist>
    </friends_getLists_response>
    XML
  end
  
  def example_get_logged_in_user_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <users_getLoggedInUser_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">1240077</users_getLoggedInUser_response>    
    XML
  end
  
  def example_invalid_api_key_error_response
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <error_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
      <error_code>101</error_code>
      <error_msg>Invalid API key</error_msg>
      <request_args list="true">
        <arg>
          <key>v</key>
          <value>1.0</value>
        </arg>
        <arg>
          <key>method</key>
          <value>facebook.auth.createToken</value>
        </arg>
        <arg>
          <key>sig</key>
          <value>611f5f44e55f3fe17f858a8de84a4b0a</value>
        </arg>
        <arg>
          <key>call_id</key>
          <value>1186088346.82142</value>
        </arg>
      </request_args>
    </error_response>    
    XML
  end
  
  def example_session_expired_error_response
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <error_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
      <error_code>102</error_code>
      <error_msg>Session Expired</error_msg>
      <request_args list="true">
        <arg>
          <key>v</key>
          <value>1.0</value>
        </arg>
        <arg>
          <key>method</key>
          <value>facebook.auth.createToken</value>
        </arg>
        <arg>
          <key>sig</key>
          <value>611f5f44e55f3fe17f858a8de84a4b0a</value>
        </arg>
        <arg>
          <key>call_id</key>
          <value>1186088346.82142</value>
        </arg>
      </request_args>
    </error_response>    
    XML
  end

  def example_app_users_xml
    <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
      <friends_getAppUsers_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
        <uid>222333</uid>
        <uid>1240079</uid>
      </friends_getAppUsers_response> 
    XML
  end
  
  def example_user_albums_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <photos_getAlbums_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <album>
        <aid>97503428432802022</aid>
        <cover_pid>97503428461115574</cover_pid>
        <owner>22701786</owner>
        <name>Summertime is Best</name>
        <created>1184120648</created>
        <modified>1185465771</modified>
        <description>Happenings on or around Summer '07</description>
        <location>Brooklyn, New York</location>
        <link>http://www.facebook.com/album.php?aid=2011366&amp;id=22701786</link>
        <size>49</size>
      </album>
      <album>
        <aid>97503428432797817</aid>
        <cover_pid>97503428460977993</cover_pid>
        <owner>22701786</owner>
        <name>Bonofon's Recital</name>
        <created>1165356279</created>
        <modified>1165382364</modified>
        <description>The whole Ewing fam flies out to flatland to watch the Bonofon's senior recital.  That boy sure can tinkle them ivories.</description>
        <location>Grinnell College, Grinnell Iowa</location>
        <link>http://www.facebook.com/album.php?aid=2007161&amp;id=22701786</link>
        <size>14</size>
      </album>
    </photos_getAlbums_response>
    XML
  end
  
  def example_upload_photo_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <photos_upload_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
      <pid>940915697041656</pid>
      <aid>940915667462717</aid>
      <owner>219074</owner>
      <src>http://ip002.facebook.com/v67/161/72/219074/s219074_31637752_5455.jpg</src>
      <src_big>http://ip002.facebook.com/v67/161/72/219074/n219074_31637752_5455.jpg</src_big>
      <src_small>http://ip002.facebook.com/v67/161/72/219074/t219074_31637752_5455.jpg</src_small>
      <link>http://www.facebook.com/photo.php?pid=31637752&id=219074</link>
      <caption>Under the sunset</caption>
    </photos_upload_response>
    XML
  end
  
  def example_new_album_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <photos_createAlbum_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">
      <aid>34595963571485</aid>
      <cover_pid>0</cover_pid>
      <owner>8055</owner>
      <name>My Empty Album</name>
      <created>1132553109</created>
      <modified>1132553363</modified>
      <description>No I will not make out with you</description>
      <location>York, PA</location>
      <link>http://www.facebook.com/album.php?aid=2002205&id=8055</link>
      <size>0</size>
    </photos_createAlbum_response>
    XML
  end
  
  def example_photo_tags_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <photos_getTags_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <photo_tag>
        <pid>97503428461115571</pid>
        <subject>570070524</subject>
        <xcoord>65.4248</xcoord>
        <ycoord>16.8627</ycoord>
      </photo_tag>
    </photos_getTags_response>
    XML
  end
  
  def example_add_tag_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <photos_addTag_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd">1</photos_addTag_response>
    XML
  end
  
  def example_get_photo_xml
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <photos_get_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://api.facebook.com/1.0/ http://api.facebook.com/1.0/facebook.xsd" list="true">
      <photo>
        <pid>97503428461115590</pid>
        <aid>97503428432802022</aid>
        <owner>22701786</owner>
        <src>http://photos-c.ak.facebook.com/photos-ak-sf2p/v77/74/112/22701786/s22701786_30324934_7816.jpg</src>
        <src_big>http://photos-c.ak.facebook.com/photos-ak-sf2p/v77/74/112/22701786/n22701786_30324934_7816.jpg</src_big>
        <src_small>http://photos-c.ak.facebook.com/photos-ak-sf2p/v77/74/112/22701786/t22701786_30324934_7816.jpg</src_small>
        <link>http://www.facebook.com/photo.php?pid=30324934&amp;id=22701786</link>
        <caption>Rooftop barbecues make me act funny</caption>
        <created>1184120987</created>
      </photo>
      <photo>
        <pid>97503428461115573</pid>
        <aid>97503428432802022</aid>
        <owner>22701786</owner>
        <src>http://photos-b.ak.facebook.com/photos-ak-sf2p/v77/74/112/22701786/s22701786_30324917_4555.jpg</src>
        <src_big>http://photos-b.ak.facebook.com/photos-ak-sf2p/v77/74/112/22701786/n22701786_30324917_4555.jpg</src_big>
        <src_small>http://photos-b.ak.facebook.com/photos-ak-sf2p/v77/74/112/22701786/t22701786_30324917_4555.jpg</src_small>
        <link>http://www.facebook.com/photo.php?pid=30324917&amp;id=22701786</link>
        <caption/>
        <created>1184120654</created>
      </photo>
    </photos_get_response>
    XML
  end
  
end
