require 'test_helper'

class DslTest < NamedSeeds::TestCase

  module T ; extend NamedSeeds::DSL ; end

  def test_includes_all_methods
    assert_equal 207281424, T.identify(:ruby)
    assert_equal 207281424, T.id(:ruby)
  end


end
