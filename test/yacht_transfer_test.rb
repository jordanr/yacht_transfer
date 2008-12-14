require File.dirname(__FILE__) + '/test_helper.rb'

class TestYachtTransfer < Test::Unit::TestCase
  class DummyTransferer
    include YachtTransfer::Transferers::AbstractTransferer
  end

  def test_login_must_be_overridden
    upper = DummyTransferer.new("a","b", nil)
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.login }
  end
  def test_create_must_be_overridden
    upper = DummyTransferer.new("a","b", nil)
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.create }
  end
  def test_update_must_be_overridden
    upper = DummyTransferer.new("a","b", nil)
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.update }
  end
  def test_delete_must_be_overridden
    upper = DummyTransferer.new("a","b", nil)
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.delete }
  end
end   

class TestYachtWorldTransfer < Test::Unit::TestCase
  def setup
    @listing= sample_listing
    @id = "2011483" #"1711800"
    @yw_username = "jordanyacht"
    @yw_password = "swel4roj"
    @yw = YachtTransfer::Transferers::YachtWorldTransferer.new(@yw_username, @yw_password, @listing, @id)

    @yw_start_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_start_page.html"))
    @yw_basic_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_basic_page.html"))
    @yw_details_page=WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_details_page.html"))
    @yw_photo_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_photo_page.html"))
    @yw_basic_with_photos_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, 
								fixture("yw_basic_with_photos_page.html"))
  end

  def test_it
    flunk
  end

  ################### 
  ##  Don't test bcuz they take too long.

  def dont_test_delete
    @yw.delete.inspect
  end

  def dont_test_update
    @yw.update
  end

  def dont_test_create
    @yw.id = nil
    @yw.create
  end

  def dont_test_yw_basic_with_photo_submit_page
    puts @yw.basic_with_photo.inspect
  end

  def dont_test_yw_photo_upload_page
    (1..3).each { |p| @yw.delete_photo(p) }
#    puts @yw.photo.inspect
  end

  def dont_test_yw_submit_details_page
    puts @yw.details.inspect
  end

  def dont_test_yw_submit_add_accommodation_page
    puts @yw.add_accommodation.inspect
  end

  def dont_test_yw_submit_start_page
     puts @yw.start.inspect
  end

  def dont_test_yw_submit_basic_page
    puts @yw.basic.inspect # edit
    @yw.id=nil
    puts @yw.basic.inspect # new
  end


  def dont_test_yacht_world_logon
    assert @yw.login
  end

  def dont_test_yacht_world_logon_fails
    yw = YachtTransfer::Transferers::YachtWorldTransferer.new("dkad", "dddd", nil)
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::LoginFailedError) { yw.login }
  end
end

class TestYachtCouncilTransfer < Test::Unit::TestCase
  def setup
    @listing= sample_listing

    @yc_username = "jys"
    @yc_password = "yacht"
    @yc = YachtTransfer::Transferers::YachtCouncilTransferer.new(@yc_username, @yc_password,@listing)
  end
  
  def test_it
    flunk
  end

  ################### 
  ##  Don't test bcuz they take too long.  
  def dont_test_yacht_council_logon
    assert @yc.login
  end

  def dont_test_yacht_council_logon_fails
    yc = YachtTransfer::Transferers::YachtCouncilTransferer.new("dkad", "dddd", nil)
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::LoginFailedError) { yc.login }
  end
end

