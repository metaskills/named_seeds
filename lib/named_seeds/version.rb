module NamedSeeds

  module VERSION
    MAJOR = 2
    MINOR = 2
    TINY  = 1
    PRE   = nil
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
  end

  def self.version
    Gem::Version.new VERSION::STRING
  end

  def self.version_string
    VERSION::STRING
  end

end
