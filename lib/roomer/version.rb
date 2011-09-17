module Roomer
  module VERSION # :nodoc:
    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 0
      TINY   = 8
      PRE    = nil

      STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')

      SUMMARY = "roomer #{STRING}"
    end
  end
end
