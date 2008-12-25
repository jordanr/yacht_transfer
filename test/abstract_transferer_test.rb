require File.dirname(__FILE__) + '/test_helper.rb'

class TestAbstractTransferer < Test::Unit::TestCase
  class DummyTransferer
    include YachtTransfer::Transferers::AbstractTransferer
  end

  def test_login_must_be_overridden
    upper = DummyTransferer.new("a","b")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.login }
  end
  def test_create_must_be_overridden
    upper = DummyTransferer.new("a","b")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.create(nil) }
  end
  def test_update_must_be_overridden
    upper = DummyTransferer.new("a","b")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.update(nil, nil) }
  end
  def test_delete_must_be_overridden
    upper = DummyTransferer.new("a","b")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.delete(nil) }
  end
end   
