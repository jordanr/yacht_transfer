require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/mock_yacht_world.rb'

class YachtTransfer::Transferers::YachtWorldTransferer
  def post(url, params)
    yw = MockYachtWorld.new()
    yw.send(url.split('/').last.split('.').first.to_sym, params)
  end
end

class TestYachtWorldTransferer < Test::Unit::TestCase
  def setup
    @listing= sample_listing
    @id = "2012331" #"1711800"
    @yw_username = "jordanyacht"
    @yw_password = "swel4roj"
    @yw = YachtTransfer::Transferers::YachtWorldTransferer.new(@yw_username, @yw_password)

#    @yw_start_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_start_page.html"))
#    @yw_basic_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_basic_page.html"))
#    @yw_details_page=WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_details_page.html"))
#    @yw_photo_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_photo_page.html"))
#    @yw_basic_with_photos_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, 
#								fixture("yw_basic_with_photos_page.html"))
  end

  def test_create_listing
    @yw.create(@listing)
  end

  def dont_test_authenticate
    assert @yw.authentic?
  end




  ################### 
  ##  Don't test bcuz they take too long.

  def dont_test_delete
    @yw.delete(@id)
  end

  def dont_test_update
    @yw.update(@listing, @id)
  end

  def dont_test_create
    @yw.create(@listing)
  end

  def dont_test_yw_basic_with_photo_submit_page
    puts @yw.basic_with_photo(@listing, @id)
  end

  def dont_test_yw_photo_upload_page
    (1..3).each { |p| @yw.delete_photo(@id, p) }
#    puts @yw.photo(@listing, @id)
  end

  def dont_test_yw_submit_details_page
    puts @yw.details(@listing, @id).inspect
  end

  def dont_test_yw_submit_add_accommodation_page
    puts @yw.add_accommodation(@listing, @id).inspect
  end

  def dont_test_yw_submit_start_page
     puts @yw.start(@listing, @id).inspect
  end

  def dont_test_yw_submit_basic_page
    puts @yw.basic(@listing, @id).inspect
  end


  def dont_test_yacht_world_logon
    assert @yw.login
  end

  def dont_test_yacht_world_logon_fails
    yw = YachtTransfer::Transferers::YachtWorldTransferer.new("dkad", "dddd")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::LoginFailedError) { yw.login }
  end
end
