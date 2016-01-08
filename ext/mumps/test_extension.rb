require_relative 'rubym'
require 'test/unit'

class TestRubyM < Test::Unit::TestCase

  def test_mumps
    t = RubyM.new
    assert_equal(Object, RubyM.superclass)
    assert_equal(RubyM, t.class)

    t.add(1)
    t.add(2)

    assert_equal([1,2], t.instance_eval("@arr"))
  end
end
