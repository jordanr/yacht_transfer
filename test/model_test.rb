require File.dirname(__FILE__) + '/test_helper.rb'
require 'rubygems'
require 'flexmock/test_unit'

class TestYachtTransfer < Test::Unit::TestCase
  class ComplexThing
    include YachtTransfer::Model
    attr_accessor :weight, :height
  end
  
  class Thing
    include YachtTransfer::Model
    attr_accessor :name, :job
    hash_settable_accessor :complex_thing, ComplexThing
    hash_settable_list_accessor :list_of_complex_things, ComplexThing
  end
  
  class PopulatingThing
    include YachtTransfer::Model
    populating_attr_accessor :first_name
    populating_hash_settable_accessor :complex_thing, ComplexThing
    populating_hash_settable_accessor *[:yess, :noo, :maybeso].push(ComplexThing)
  end

  def test_populating_hash_settable_accessor_populates_for_one_symbol
    t = PopulatingThing.new
    flexmock(t).should_receive(:populate).once
    t.complex_thing
  end

  def test_populating_hash_settable_accessor_populates_for_many_symbols
    t = PopulatingThing.new
    flexmock(t).should_receive(:populate).times(3)
    t.method(:yess).call
    t.method(:noo).call
    t.method(:maybeso).call
  end

  def test_populating_hash_settable_accessor_is_hash_settable_for_one_symbol
    t = PopulatingThing.new({})
    t.complex_thing = {:weight => 123, :height => 5.4}
    flexmock(t).should_receive(:populated?).and_return(true)
    flexmock(t).should_receive(:populate).never
    t.complex_thing
  end

  def test_populating_hash_settable_accessor_is_hash_settable_for_many_symbols
    t = PopulatingThing.new({})
    t.complex_thing = {:weight => 123, :height => 5.4}
    flexmock(t).should_receive(:populated?).and_return(true).times(3)
    flexmock(t).should_receive(:populate).never
    t.method(:yess).call
    t.method(:noo).call
    t.method(:maybeso).call
  end
  
  def test_can_instantiate_an_object_with_a_hash
    h = {:name => "Blob", :job => "Monster"}
    assert_equal("Blob", Thing.from_hash(h).name)
  end
  
  def test_if_no_hash_is_given_to_model_constructor_no_attributes_are_set
    assert_nothing_raised {
      t = Thing.new
      assert_nil(t.name)
    }
  end
  
  def test_can_declare_hash_settable_attributes
    t = Thing.new({})
    t.complex_thing = {:weight => 123, :height => 5.4}
    assert_equal(123, t.complex_thing.weight)
    t.complex_thing = ComplexThing.new(:weight => 321)
    assert_equal(321, t.complex_thing.weight)
  end
  
  def test_can_declare_attributes_which_are_settable_via_a_list_of_hashes
    t = Thing.new
    t.list_of_complex_things = [{:weight => 444, :height => 123.0}, {:weight => 222, :height => 321.1}]
    assert_equal("123.0, 321.1", t.list_of_complex_things.map{|ct| ct.height.to_s}.sort.join(', '))
    t.list_of_complex_things = [ComplexThing.new(:weight => 555), ComplexThing.new(:weight => 111)]
    assert_equal("111, 555", t.list_of_complex_things.map{|ct| ct.weight.to_s}.sort.join(', '))
  end
  
  def test_if_you_try_to_use_a_models_session_without_initializing_it_first_you_get_a_descriptive_error
    t = Thing.new
    assert_raises(YachtTransfer::Model::UnboundSessionException) {
      t.session
    }
  end
  
  def test_populating_reader_will_call_populate_if_model_was_not_previously_populated
    t = PopulatingThing.new
    flexmock(t).should_receive(:populate).once
    t.first_name
  end
  
  def test_populating_reader_will_not_call_populate_if_model_was_previously_populated
    t = PopulatingThing.new
    flexmock(t).should_receive(:populated?).and_return(true)
    flexmock(t).should_receive(:populate).never
    t.first_name
  end
  
  def test_attempting_to_access_a_populating_reader_will_raise_an_exception_if_populate_was_not_defined
    t = PopulatingThing.new
    assert_raises(NotImplementedError) {
      t.first_name
    }
  end
end

