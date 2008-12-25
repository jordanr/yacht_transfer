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
  def dont_test_yacht_council_logon
    assert @yc.login
  end

  def dont_test_yacht_council_logon_fails
    yc = YachtTransfer::Transferers::YachtCouncilTransferer.new("dkad", "dddd")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::LoginFailedError) { yc.login }
  end
end

