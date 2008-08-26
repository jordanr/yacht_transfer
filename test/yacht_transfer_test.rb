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
    @yw_start_page_hash = {:maker=> "whatever", :year=>"1111", "length"=>"33", "units"=>"Meters", :dummy=>"nomatter" }
   
    @listing= sample_listing
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

  def test_fill_out_form
    form = @yw_start_page.forms.first
    form = @yw.fill_out_form!(form, @yw_start_page_hash.clone)
    form.fields.each { |f|
	assert_equal f.value, @yw_start_page_hash[f.name] if @yw_start_page_hash.has_key?(f.name)
    }
#    puts form.inspect
  end

  def test_fill_out_yw_start_page_with_listing
    
    form = @yw_start_page.forms.first
    hashh = @listing.to_yw
    form = @yw.fill_out_form!(form, @listing.to_yw)
    
    assert_equal form.maker, @listing.yacht.manufacturer
    assert_equal form.year, @listing.yacht.year
    assert_equal form.length, @listing.yacht.length.value
    assert_equal form.units, @listing.yacht.length.units
    
#    puts form.inspect
  end


################### 
##  Don't test bcuz they take too long.
  def dont_test_yacht_council_logon
    assert @yc.login
  end

  def dont_test_yacht_council_logon_fails
    yc = Js2Fbjs::Uploaders::YachtCouncilUploader.new("dkad", "dddd")
    assert_raises(Js2Fbjs::Uploaders::BaseUploader::LoginFailedError) { yc.login }
  end

  def dont_test_yacht_world_logon
    assert @yw.login
  #  p @yw_start_page.forms
  #  File.open("yw_test", "w") << x
  end

  def dont_test_yacht_world_logon_fails
    yw = Js2Fbjs::Uploaders::YachtWorldUploader.new("dkad", "dddd")
    assert_raises(Js2Fbjs::Uploaders::BaseUploader::LoginFailedError) { yw.login }
  end
################

end
