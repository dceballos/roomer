module Roomer
  module VERSION # :nodoc:
    unless defined? MAJOR
      MAJOR  = 1
      MINOR  = 0
      TINY   = 1
      PRE    = nil

      STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')

      SUMMARY = "roomer #{STRING}"
    end
  end
end
