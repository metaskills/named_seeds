require 'test_helper'

class BaseTest < NamedSeeds::Spec
  
  describe 'identifiy' do
    
    it 'works on strings' do
      NamedSeeds.identify('foo').must_equal NamedSeeds.identify('foo')
      NamedSeeds.identify('foo').wont_equal NamedSeeds.identify('FOO')
    end
    
    it 'works on symbols' do
      NamedSeeds.identify(:foo).must_equal NamedSeeds.identify(:foo)
    end
    
    it 'identifies consistently' do
      NamedSeeds.identify(:ruby).must_equal 207281424
      NamedSeeds.identify(:sapphire_2).must_equal 1066363776
    end
    
  end
  
end
