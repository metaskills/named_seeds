require 'zlib'

module NamedSeeds
  
  # A direct copy of ActiveRecord::Fixtures.identify.
  # Returns a consistent, platform-independent identifier for +label+ that are positive integers less than 2^32.
  def self.identify(label)
    Zlib.crc32(label.to_s) % (2 ** 30 - 1)
  end

end  
