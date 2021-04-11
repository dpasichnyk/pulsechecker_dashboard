require_dependency 'app_mode/error'

# OPTIMIZE: Place this and all other error classes under `Error::`. Make them `Error:SomeCase`.

module AppMode
  class SubsystemNotEnabled < Error
  end
end

#
# Implementation notes:
#
# * Name is "subsystem not enabled" since it's an unambiguous condition statement. Tried
#   "subsystem disabled", sounds vague at times.
