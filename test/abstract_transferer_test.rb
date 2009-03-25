require File.dirname(__FILE__) + '/test_helper.rb'

class TestAbstractTransferer < Test::Unit::TestCase
  class DummyTransferer
    include YachtTransfer::Transferers::AbstractTransferer
  end

  def test_login_must_be_overridden
    upper = DummyTransferer.new("a","b")
    assert_raises(YachtTransfer::Transferers::AbstractTransferer::NotImplementedError) { upper.authentic? }
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

  def test_post
    d = DummyTransferer.new("a", "b")
    assert d.post("http://www.interlacken.com/webdbdev/ch05/formpost.asp", { :box1=>"Alden", :button1=>"Submit" } )
  end

  def test_get
    d = DummyTransferer.new("a", "b")
    assert d.get("http://www.google.com/")
  end

  def dont_test_multipart_post
    d = DummyTransferer.new("a", "b")
    assert d.multipart_post("http://www.htmlcodetutorial.com/cgi-bin/mycgi.pl", {:file => picture_fixture("rails.png") })     
  end

end   
