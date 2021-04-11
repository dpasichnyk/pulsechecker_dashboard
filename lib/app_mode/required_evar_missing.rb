require_dependency 'app_mode/error'

# OPTIMIZE: Place this and all other error classes under `Error::`. Make them `Error:SomeCase`.

module AppMode
  class RequiredEvarMissing < Error
  end
end
