module AppMode
  # Base class for all mode errors.
  class Error < StandardError
  end
end

#
# Implementation notes:
#
# * Final classes inheriting from `Error` reside in convention-named files to make Rails autoload
#   happy, esp. after `reload!`.
