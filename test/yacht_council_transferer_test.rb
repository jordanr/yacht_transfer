require File.dirname(__FILE__) + '/test_helper.rb'

class TestYachtCouncilTransfer < Test::Unit::TestCase
  def setup
    @listing= sample_listing

    @yc_username = "jys"
    @yc_password = "yacht"
    @yc = YachtTransfer::Transferers::YachtCouncilTransferer.new(@yc_username, @yc_password)
  end
  
  def test_it
    flunk
  end

  ################### 
  ##  Don't test bcuz they take too long.  
  def test_yacht_council_authentic
    assert @yc.authentic?
  end

  def test_yacht_council_not_authentic
    yc = YachtTransfer::Transferers::YachtCouncilTransferer.new("dkad", "dddd")
    assert ! yc.authentic?
  end

end

