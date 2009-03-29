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
    @id = "86580"
    @yc_username = "jys"
    @yc_password = "yacht"
    @yc = YachtCouncil.new(@yc_username, @yc_password)
    @real_yc = YachtTransfer::Transferers::YachtCouncilTransferer.new(@yc_username, @yc_password)
  end

  def test_authentic
    assert @yc.authentic?
  end

  def test_not_authentic
    yc = YachtTransfer::Transferers::YachtCouncilTransferer.new("dkad", "dddd")
    assert ! yc.authentic?
  end

  def test_create
    assert_equal @id, @yc.create(@listing)
  end
end

