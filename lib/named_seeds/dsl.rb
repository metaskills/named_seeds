require 'zlib'

module NamedSeeds
  module DSL

    MAX_ID = 2 ** 30 - 1

    # Copy of ActiveRecord::Fixtures.identify method.
    # Returns a consistent, platform-independent identifier for +label+.
    # Integer identifiers are values less than 2^30.
    # UUIDs are RFC 4122 version 5 SHA-1 hashes.
    #
    def identify(label, column_type = :integer)
      if column_type == :uuid
        NamedSeeds.uuid_v5(label)
      else
        Zlib.crc32(label.to_s) % MAX_ID
      end
    end
    alias_method :id, :identify

  end
end

