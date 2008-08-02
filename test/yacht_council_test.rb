class YachtCouncilLogonTest < Test::Unit::TestCase

  def test_should_secure
    @yc_session = YachtTransfer::Session.new(YachtTransfer::Services::YachtCouncil, 'jys', 'yacht')
    @yc_session.secure!
    assert @yc_session.secured?
  end

  def test_should_not_secure
    @yc_session = YachtTransfer::Session.new(YachtTransfer::Services::YachtCouncil, 'jys', 'badyacht')
    @yc_session.secure!
    assert !@yc_session.secured?
  end
end

class YachtCouncilListingsTest < Test::Unit::TestCase
  def setup
    @yc_session = YachtTransfer::Session.new(YachtTransfer::Services::YachtCouncil, 'jys', 'yacht')
  end

  def test_a
    flunk
  end
end
