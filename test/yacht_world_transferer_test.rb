require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/mock_yacht_world.rb'

class YachtWorld < YachtTransfer::Transferers::YachtWorldTransferer
  def post(url, params)
    method = url.split('/').last.split('.').first.to_sym
    yw = MockYachtWorld.new()
    url.split('?').last.split('&').each { |keyvalue| 
	pair = keyvalue.split('=')
	params.merge!(pair.first.to_sym => pair.last)
    }
    yw.send(method, params)
  end

  def multipart_post(url, params, headers=nil)
    method = url.split('/').last.split('.').first.to_sym
    yw = MockYachtWorld.new()
    url.split('?').last.split('&').each { |keyvalue| 
	pair = keyvalue.split('=')
	params.merge!(pair.first.to_sym => pair.last)
    }
    yw.send(method, params)
  end

  def get(url)
    yw = MockYachtWorld.new()
    method = url.split('/').last.split('.').first.to_sym
    params = {}
    url.split('?').last.split('&').each { |keyvalue| 
	pair = keyvalue.split('=')
	params.merge!(pair.first.to_sym => pair.last)
    }
    yw.send(method, params)
  end
end

class TestYachtWorldTransferer < Test::Unit::TestCase
  def setup
    @listing= sample_listing
    @id_one = 1758881
    @id_two = 1711800
    @yw_username = "jordanyacht"
    @yw_password = "swel4roj"
    @yw = YachtWorld.new(@yw_username, @yw_password)
    @real_yw = YachtTransfer::Transferers::YachtWorldTransferer.new(@yw_username, @yw_password)

#    @yw_start_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_start_page.html"))
#    @yw_basic_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_basic_page.html"))
#    @yw_details_page=WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_details_page.html"))
#    @yw_photo_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, fixture("yw_photo_page.html"))
#    @yw_basic_with_photos_page = WWW::Mechanize::Page.new(nil, { 'content-type'=>'text/html'}, 
#								fixture("yw_basic_with_photos_page.html"))
  end

  def test_create_listing
    assert @yw.create(@listing) == @id_one
  end

  def test_delete_listing
    ids = [@id_one, @id_two]
    ids.each { |id| assert @yw.delete(id) }
  end

  def test_update_listing
    assert @yw.update(@listing, @id_one)
  end

  def test_create_photo
    assert @yw.photo( {1 => {:fileName_1 => picture_fixture("rails.png"), :submit => "Save Photo"} }, @id_one)
  end
  
  def test_delete_photo
    id = @id_one 
    ps = [2,3]
    ps.each { |p| assert @yw.delete_photo(id,p) }
  end


  ################### 
  ##  Don't test bcuz they take too long.
  def dont_test_authentic
    assert @yw.authentic?
  end

  def dont_test_not_authentic
    yw = YachtTransfer::Transferers::YachtWorldTransferer.new("dkad", "dddd")
    assert ! yw.authentic?
  end

  def dont_test_yw_basic_with_photo_submit_page
    puts @yw.basic_with_photo(@listing, @id)
  end


  def dont_test_yw_submit_details_page
    puts @yw.details(@listing, @id).inspect
  end

  def dont_test_yw_submit_add_accommodation_page
    puts @yw.add_accommodation(@listing, @id).inspect
  end

  def dont_test_yw_submit_basic_page
    puts @yw.basic(@listing, @id).inspect
  end

end
