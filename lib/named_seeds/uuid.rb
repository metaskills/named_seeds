require 'securerandom'

module NamedSeeds

  # Copy of ActiveSupport's Digest::UUID extension for v5 UUIDs.
  # Needed to maintain backward compatibility with Rails 4.0 and 4.1.
  #
  def self.uuid_v5(name)
    hash = Digest::SHA1.new
    hash.update("k\xA7\xB8\x12\x9D\xAD\x11\xD1\x80\xB4\x00\xC0O\xD40\xC8")
    hash.update(name.to_s)
    ary = hash.digest.unpack('NnnnnN')
    ary[2] = (ary[2] & 0x0FFF) | (5 << 12)
    ary[3] = (ary[3] & 0x3FFF) | 0x8000
    "%08x-%04x-%04x-%04x-%04x%08x" % ary
  end

end
