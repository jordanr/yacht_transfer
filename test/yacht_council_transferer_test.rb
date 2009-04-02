require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/mock_yacht_council.rb'

class YachtCouncil < YachtTransfer::Transferers::YachtCouncilTransferer
  def post(url, params, headers =nil)
    method = url.split('/').last.split('.').first.to_sym
    yc = MockYachtCouncil.new()
    url.split('?').last.split('&').each { |keyvalue| 
        pair = keyvalue.split('=')
        params.merge!(pair.first.to_sym => pair.last)
    }
    yc.send(method.to_s.gsub("-", "_"), params)
  end

  def multipart_post(url, params, headers=nil)
    method = url.split('/').last.split('.').first.to_sym
    yc = MockYachtCouncil.new()
    url.split('?').last.split('&').each { |keyvalue| 
        pair = keyvalue.split('=')
        params.merge!(pair.first.to_sym => pair.last)
    }
    yc.send(method.to_s.gsub("-", "_"), params)
  end

  def get(url, headers =nil)
    params = {}
    method = url.split('/').last.split('.').first.to_sym
    yc = MockYachtCouncil.new()
    url.split('?').last.split('&').each { |keyvalue| 
        pair = keyvalue.split('=')
        params.merge!(pair.first.to_sym => pair.last)
    }
    yc.send(method.to_s.gsub("-", "_"), params)
  end
end

class TestYachtCouncilTransfer < Test::Unit::TestCase
  def setup
    @listing= sample_listing

    @broker_id = "3910"
    @LoginID = "1919"
    @MemberID= "411"

    @id = "86580"
    @id_two = "86579"

    @yc_username = "jys"
    @yc_password = "yacht"
    @yc = YachtCouncil.new(@yc_username, @yc_password)
    @real_yc = YachtTransfer::Transferers::YachtCouncilTransferer.new(@yc_username, @yc_password)
  end

  def test_authentic
    assert @yc.authentic?
  end

  def test_not_authentic
    yc = YachtCouncil.new("dkad", "ddd") #YachtTransfer::Transferers::YachtCouncilTransferer.new("dkad", "dddd")
    assert ! yc.authentic?
  end

  def test_basic
    listing = YachtTransfer::Standards::YachtCouncilHash.new(@listing)

    listing.merge!({:member_company_id =>@MemberID, :login_id=>@LoginID } )
    listing.merge!(:broker_id => "3910")

    listing.to_yc!
    assert_equal '11111', @yc.basic(listing.basic) #@listing)
  end

  def test_basic_update
    listing = YachtTransfer::Standards::YachtCouncilHash.new(@listing)

    listing.merge!({:member_company_id =>@MemberID, :login_id=>@LoginID } )
    listing.merge!(:broker_id => "3910")
    listing.merge!(:id =>@id_two)
    listing.to_yc!
    assert_equal @id_two, @yc.basic(listing.basic)
  end

  def test_create_photo
    listing = YachtTransfer::Standards::YachtCouncilHash.new(@listing)
    listing.merge!({:member_company_id =>@MemberID, :login_id=>@LoginID } )
    listing.merge!(:broker_id => "3910")

    listing.merge!(:id =>@id_two)
    listing.to_yc!
      
    assert @real_yc.photo(listing.photo)
  end                             

  def test_delete_photo         
#    id = @id_one             
#    ps = [2,3]
#    ps.each { |p| assert @yw.delete_photo(id,p) }
  end


end

