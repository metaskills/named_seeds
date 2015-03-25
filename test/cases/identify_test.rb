require 'test_helper'

class IdentifyTest < NamedSeeds::TestCase

  def test_works_on_strings
    assert_equal     id('foo'), id('foo')
    assert_not_equal id('FOO'), id('foo')
  end

  def test_works_on_symbols
    assert_equal id('foo'), id(:foo)
  end

  def test_identifies_consistently
    assert_equal 207281424,  id(:ruby)
    assert_equal 1066363776, id(:sapphire_2)
  end

  def test_can_generate_uuid_identities
    assert_match '4f156606-8cb3-509e-a177-956ca0a22015', id(:ken, :uuid)
  end

end
